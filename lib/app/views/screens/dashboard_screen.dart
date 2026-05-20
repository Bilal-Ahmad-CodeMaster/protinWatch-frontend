import 'package:crio_app/app/views/screens/alert_screen_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/sequence_model.dart';
import '../../controllers/map_controller.dart' as custom_map;
import 'fullscreen_map_screen.dart';
import '../../controllers/sequence_controller.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Marker _buildMarker(BuildContext context, SequenceModel seq, double w) {
    final score = seq.threatScore.combinedThreatIndex;
    final isCritical = score > 75;
    final color = isCritical
        ? AppTheme.criticalRed
        : (score >= 50 ? AppTheme.warningAmber : AppTheme.safeGreen);
    final label = seq.name.split(' ').first;

    return Marker(
      point: LatLng(seq.latitude, seq.longitude),
      width: w * 0.2,
      height: w * 0.05,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isCritical)
                Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color.withValues(alpha: 0.3),
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.5, 1.5),
                    )
                    .fade(end: 0),

              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: w * 0.022,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text, double w) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: w * 0.015,
          height: w * 0.015,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: w * 0.015),
        Text(
          text,
          style: GoogleFonts.outfit(
            color: AppTheme.secondaryText,
            fontSize: w * 0.022,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final SequenceController sequenceController =
        Get.find<SequenceController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // 1. Top Section - Map Card Container
          Container(
            height: h * 0.38,
            width: double.infinity,
            margin: EdgeInsets.symmetric(
              horizontal: w * 0.04,
              vertical: w * 0.02,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppTheme.cardBorder, width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Stack(
                children: [
                  // Map Widget
                  Obx(() {
                    final sequences = sequenceController.sequences.isEmpty
                        ? custom_map.MapController.defaultMapMarkers
                        : sequenceController.sequences;

                    return FlutterMap(
                      options: const MapOptions(
                        initialCenter: LatLng(25, 10),
                        initialZoom: 1.2,
                        interactionOptions: InteractionOptions(
                          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
                          userAgentPackageName: 'com.proteinwatch.crio_app',
                        ),
                        MarkerLayer(
                          markers: sequences
                              .map((seq) => _buildMarker(context, seq, w))
                              .toList(),
                        ),
                      ],
                    );
                  }),

                  // Red Alerts Badge (Top Right)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.criticalRed,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.criticalRed.withValues(alpha: 0.4),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Obx(() {
                        final list = sequenceController.sequences.isEmpty
                            ? custom_map.MapController.defaultMapMarkers
                            : sequenceController.sequences;
                        final count = list
                            .where(
                              (s) => s.threatScore.combinedThreatIndex > 75,
                            )
                            .length;
                        return Text(
                          '$count RED ALERTS',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: w * 0.025,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        );
                      }),
                    ),
                  ),

                  // Legend (Bottom Left)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.background.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildLegendDot(AppTheme.criticalRed, 'Critical', w),
                          SizedBox(width: w * 0.02),
                          _buildLegendDot(AppTheme.warningAmber, 'Monitor', w),
                          SizedBox(width: w * 0.02),
                          _buildLegendDot(AppTheme.safeGreen, 'Safe', w),
                        ],
                      ),
                    ),
                  ),

                  // Fullscreen expand button (bottom-right)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () => Get.to(
                        () => const FullscreenMapScreen(),
                        transition: Transition.fadeIn,
                        duration: const Duration(milliseconds: 400),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(w * 0.022),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSurface.withValues(alpha: 0.88),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.infoBlue.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.infoBlue.withValues(alpha: 0.3),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.fullscreen_rounded,
                          color: AppTheme.infoBlue,
                          size: w * 0.045,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 500.ms).scale(begin: const Offset(0.95, 0.95)),

          // 2. Header Row: "Live signals" & "● NCBI · 6h cycle"
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.05,
              vertical: w * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live signals',
                  style: GoogleFonts.outfit(
                    color: AppTheme.primaryText,
                    fontSize: w * 0.05,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppTheme.safeGreen,
                                shape: BoxShape.circle,
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .fade(),
                        const SizedBox(width: 6),
                        Obx(
                          () => Text(
                            'NCBI · ${sequenceController.formattedTimeRemaining}',
                            style: GoogleFonts.outfit(
                              color: AppTheme.safeGreen,
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 3. Scrollable List of Signals
          Expanded(
            child: Obx(() {
              final sequences = sequenceController.sequences.isEmpty
                  ? custom_map.MapController.defaultMapMarkers
                  : sequenceController.sequences;
              return RefreshIndicator(
                color: AppTheme.infoBlue,
                backgroundColor: AppTheme.cardSurface,
                onRefresh: () => sequenceController.refreshData(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: w * 0.04,
                    right: w * 0.04,
                    top: w * 0.01,
                    bottom: MediaQuery.of(context).padding.bottom + w * 0.25,
                  ),
                  itemCount: sequences.length,
                  itemBuilder: (context, index) {
                    final seq = sequences[index];
                    final score = seq.threatScore.combinedThreatIndex;
                    final color = score > 75
                        ? AppTheme.criticalRed
                        : (score >= 50
                              ? AppTheme.warningAmber
                              : AppTheme.safeGreen);

                    return GestureDetector(
                          onTap: () {
                            Get.to(() => AlertDetailsPage(alert: seq));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: w * 0.02),
                            padding: EdgeInsets.symmetric(
                              horizontal: w * 0.04,
                              vertical: w * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.cardSurface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: color.withValues(alpha: 0.25),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: w * 0.03,
                                  height: w * 0.03,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.5),
                                        blurRadius: 6,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: w * 0.03),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        seq.name,
                                        style: GoogleFonts.outfit(
                                          color: AppTheme.primaryText,
                                          fontWeight: FontWeight.bold,
                                          fontSize: w * 0.038,
                                        ),
                                      ),
                                      SizedBox(height: w * 0.003),
                                      Text(
                                        seq.originLocation,
                                        style: GoogleFonts.outfit(
                                          color: AppTheme.secondaryText,
                                          fontSize: w * 0.03,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '$score',
                                  style: GoogleFonts.outfit(
                                    color: color,
                                    fontWeight: FontWeight.w800,
                                    fontSize: w * 0.045,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .animate()
                        .fade(delay: (50 * index).ms)
                        .slideY(begin: 0.05);
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
