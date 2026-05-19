import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/protein_viewer_controller.dart';
import '../../../theme/app_theme.dart';
import 'fullscreen_protein_viewer.dart';

/// The controls bar (Zoom In, Zoom Out, Reset, Highlight, Fullscreen) for the Protein Viewer.
class ProteinViewerControls extends StatelessWidget {
  final ProteinViewerController controller;
  final String? proteinName;
  final bool highlightActive;

  const ProteinViewerControls({
    super.key,
    required this.controller,
    required this.proteinName,
    required this.highlightActive,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.only(
        left: w * 0.02,
        right: w * 0.02,
        bottom: w * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildControlIcon(
            Icons.zoom_in,
            () => controller.controller.runJavaScript("zoomIn()"),
            w,
          ),
          SizedBox(width: w * 0.015),
          _buildControlIcon(
            Icons.zoom_out,
            () => controller.controller.runJavaScript("zoomOut()"),
            w,
          ),
          SizedBox(width: w * 0.015),
          _buildControlIcon(
            Icons.refresh,
            () => controller.controller.runJavaScript("resetView()"),
            w,
          ),
          SizedBox(width: w * 0.015),
          _buildControlIcon(
            Icons.center_focus_strong,
            () => controller.controller.runJavaScript(
              "highlightBindingSite('7-19')",
            ),
            w,
            highlighted: true,
          ),
          SizedBox(width: w * 0.015),
          _buildControlIcon(Icons.fullscreen, () async {
            // 1. Unmount the inline WebView
            controller.isFullscreen.value = true;
            // 2. Wait for it to completely detach from the OS view tree (150ms)
            await Future.delayed(const Duration(milliseconds: 150));

            if (context.mounted) {
              // 3. Mount the fullscreen WebView
              controller.isFullscreenMounted.value = true;

              // 4. Push the fullscreen page
              await Get.to(
                () => FullscreenProteinViewer(
                  controller: controller,
                  proteinName: proteinName ?? 'Betacoronavirus Glycoprotein',
                  onClose: () async {
                    controller.isFullscreenMounted.value = false;
                    await Future.delayed(const Duration(milliseconds: 150));
                    Get.back();
                  },
                ),
              );
            }
            await Future.delayed(const Duration(milliseconds: 250));
            controller.isFullscreen.value = false;
          }, w),
        ],
      ),
    );
  }

  // Control icon button builder helper
  Widget _buildControlIcon(
    IconData icon,
    VoidCallback onTap,
    double w, {
    bool highlighted = false,
  }) {
    final isActive = highlighted && highlightActive;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.08,
        height: w * 0.08,
        decoration: BoxDecoration(
          color: isActive
              ? AppTheme.infoBlue.withValues(alpha: 0.15)
              : AppTheme.cardSurface,
          border: Border.all(
            color: isActive ? AppTheme.infoBlue : AppTheme.cardBorder,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: w * 0.04,
          color: isActive ? AppTheme.infoBlue : AppTheme.secondaryText,
        ),
      ),
    );
  }
}
