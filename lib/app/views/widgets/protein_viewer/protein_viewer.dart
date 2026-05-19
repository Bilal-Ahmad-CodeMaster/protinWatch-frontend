import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/protein_viewer_controller.dart';
import 'protein_viewer_top_bar.dart';
import 'protein_viewer_detail_panel.dart';
import 'protein_viewer_legend.dart';
import 'protein_viewer_modes.dart';
import 'protein_viewer_controls.dart';

/// Interactive 3D viewer for protein structure and metadata domains.
class ProteinViewer extends StatefulWidget {
  final String pdbData;
  final String? proteinName;

  const ProteinViewer({super.key, required this.pdbData, this.proteinName});

  @override
  State<ProteinViewer> createState() => _ProteinViewerState();
}

class _ProteinViewerState extends State<ProteinViewer>
    with TickerProviderStateMixin {
  String? selectedRegion;
  String selectedMode = 'ball';
  bool highlightActive = true;

  // Animation Controllers
  late final AnimationController _pulseController;
  late final AnimationController _panelController;

  // Pulse Animations
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // Mapping of NGL PDB selections
  final Map<String, String> regionSelections = {
    'rbd': '319-541',
    'helix': '12-89',
    'loop': '220-318',
    'tm': '550-620',
  };

  @override
  void initState() {
    super.initState();

    // Pulse Dot Controller Setup
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseOpacity = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    // Detail Panel Controller Setup
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _panelController.dispose();
    super.dispose();
  }

  // Set selected region and trigger NGL highlight
  void selectRegion(String key, WebViewController controller) {
    setState(() {
      selectedRegion = key;
    });
    _panelController.forward();

    final selection = regionSelections[key];
    if (selection != null) {
      controller.runJavaScript("highlightBindingSite('$selection')");
    }
  }

  // Dismiss region details and reset NGL view
  void closeDetail(WebViewController controller) {
    _panelController.reverse().then((_) {
      setState(() {
        selectedRegion = null;
      });
    });
    controller.runJavaScript("resetView()");
  }

  // Switch NGL representation style
  void _setRepresentation(String mode, WebViewController controller) {
    setState(() {
      selectedMode = mode;
    });
    controller.runJavaScript("setRepresentation('${mode.toLowerCase()}')");
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.put(
      ProteinViewerController(pdbData: widget.pdbData),
      tag: widget.pdbData,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final double parentHeight = constraints.maxHeight;
        final double w = MediaQuery.sizeOf(context).width;

        final double webViewHeight = parentHeight.isFinite
            ? (parentHeight - 142.0).clamp(142.0, 480.0)
            : 280.0;

        return Obx(() {
          final bool isConstrained = parentHeight.isFinite;
          final double cardHeight = isConstrained
              ? parentHeight.clamp(142.0, 480.0)
              : 0.0;

          if (c.hasError.value) {
            return Container(
              height: isConstrained ? cardHeight : webViewHeight + 100,
              decoration: BoxDecoration(
                color: AppTheme.background,
                border: Border.all(color: AppTheme.cardBorder, width: 0.5),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'Failed to load 3D Viewer',
                  style: TextStyle(color: AppTheme.criticalRed),
                ),
              ),
            );
          }

          Widget cardContent = Container(
            decoration: BoxDecoration(
              color: AppTheme.background,
              border: Border.all(color: AppTheme.cardBorder, width: 0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.hardEdge,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Bar
                  ProteinViewerTopBar(
                    proteinName: widget.proteinName,
                    pulseController: _pulseController,
                    pulseScale: _pulseScale,
                    pulseOpacity: _pulseOpacity,
                  ),
                  const Divider(
                    color: AppTheme.cardBorder,
                    height: 0.5,
                    thickness: 0.5,
                  ),

                  // WebView Area (with stacked details overlay drawer to prevent vertical truncation!)
                  SizedBox(
                    height: webViewHeight,
                    child: Stack(
                      children: [
                        if (!c.isFullscreen.value)
                          WebViewWidget(controller: c.controller)
                        else
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fullscreen_exit,
                                  color: AppTheme.secondaryText,
                                  size: 24,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Viewing in Fullscreen...",
                                  style: TextStyle(
                                    color: AppTheme.secondaryText,
                                    fontSize: w * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (c.isLoading.value)
                          const Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.infoBlue,
                            ),
                          ),

                        // Tap Hint Overlay
                        if (selectedRegion == null)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: w * 0.025),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.background.withValues(
                                    alpha: 0.8,
                                  ),
                                  border: Border.all(
                                    color: AppTheme.cardBorder,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.03,
                                  vertical: w * 0.015,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.touch_app_outlined,
                                      size: w * 0.032,
                                      color: AppTheme.secondaryText,
                                    ),
                                    SizedBox(width: w * 0.01),
                                    Text(
                                      "Tap a region to inspect",
                                      style: GoogleFonts.outfit(
                                        fontSize: w * 0.025,
                                        color: AppTheme.secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        // Sliding Detail Panel Overlay Drawer
                        ProteinViewerDetailPanel(
                          panelController: _panelController,
                          selectedRegion: selectedRegion,
                          webViewHeight: webViewHeight,
                          onCloseDetail: () => closeDetail(c.controller),
                          onSelectRegion: (key) =>
                              selectRegion(key, c.controller),
                        ),
                      ],
                    ),
                  ),

                  // Legend Row
                  ProteinViewerLegend(
                    selectedRegion: selectedRegion,
                    onSelectRegion: (key) => selectRegion(key, c.controller),
                  ),

                  // Render Mode Pills
                  ProteinViewerModes(
                    selectedMode: selectedMode,
                    onSetRepresentation: (mode) =>
                        _setRepresentation(mode, c.controller),
                  ),

                  // Control Buttons Row
                  ProteinViewerControls(
                    controller: c,
                    proteinName: widget.proteinName,
                    highlightActive: highlightActive,
                  ),
                ],
              ),
            ),
          );

          if (isConstrained) {
            return SizedBox(height: cardHeight, child: cardContent);
          }
          return cardContent;
        });
      },
    );
  }
}
