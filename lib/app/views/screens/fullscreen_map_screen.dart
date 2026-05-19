import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart' hide MapController;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import '../../controllers/map_controller.dart' as custom_map;
import '../../models/sequence_model.dart';

class FullscreenMapScreen extends StatefulWidget {
  const FullscreenMapScreen({super.key});

  @override
  State<FullscreenMapScreen> createState() => _FullscreenMapScreenState();
}

class _FullscreenMapScreenState extends State<FullscreenMapScreen> {
  final custom_map.MapController _mapController =
      Get.find<custom_map.MapController>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Color _threatColor(int score) => score >= 75
      ? AppTheme.criticalRed
      : (score >= 50 ? AppTheme.warningAmber : AppTheme.safeGreen);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Obx(() {
        final sequences = _mapController.markers;
        final criticalCount = sequences
            .where((s) => s.threatScore.combinedThreatIndex >= 75)
            .length;

        return Stack(
          children: [
            // ── Full-screen map ──────────────────────────────────────────
            FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(25, 10),
                initialZoom: 2.2,
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
            ),

            // ── TOP HUD ─────────────────────────────────────────────────
            Positioned(
                  top: MediaQuery.of(context).padding.top + w * 0.03,
                  left: w * 0.04,
                  right: w * 0.04,
                  child: Row(
                    children: [
                      // Back button
                      GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(w * 0.028),
                              decoration: BoxDecoration(
                                color: AppTheme.cardSurface.withValues(
                                  alpha: 0.85,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.cardBorder),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: AppTheme.primaryText,
                                size: w * 0.045,
                              ),
                            ),
                          )
                          .animate()
                          .fade(duration: 400.ms)
                          .scale(
                            begin: const Offset(0.8, 0.8),
                            duration: 400.ms,
                          ),

                      SizedBox(width: w * 0.03),

                      // Title pill
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.025,
                            vertical: w * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.cardSurface.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppTheme.cardBorder),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.public,
                                color: AppTheme.infoBlue,
                                size: w * 0.048,
                              ),
                              SizedBox(width: w * 0.025),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Global Threat Tracker',
                                      style: GoogleFonts.outfit(
                                        color: AppTheme.primaryText,
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.03,
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                    Text(
                                      '${sequences.length} active signals',
                                      style: GoogleFonts.outfit(
                                        color: AppTheme.secondaryText,
                                        fontSize: w * 0.025,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Live badge
                              Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: w * 0.015,
                                      vertical: w * 0.005,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.criticalRed.withValues(
                                        alpha: 0.18,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: AppTheme.criticalRed,
                                        width: 0.2,
                                      ),
                                    ),
                                    child: Text(
                                      'Live',
                                      style: GoogleFonts.outfit(
                                        color: AppTheme.criticalRed,
                                        fontWeight: FontWeight.w600,
                                        fontSize: w * 0.027,
                                      ),
                                    ),
                                  )
                                  .animate(
                                    onPlay: (c) => c.repeat(reverse: true),
                                  )
                                  .fade(),
                            ],
                          ),
                        ),
                      ),

                      if (criticalCount > 0) ...[
                        SizedBox(width: w * 0.03),
                        Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.02,
                                vertical: w * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.criticalRed,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.criticalRed.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$criticalCount',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.primaryText,
                                      fontWeight: FontWeight.w800,
                                      fontSize: w * 0.04,
                                    ),
                                  ),
                                  Text(
                                    'Critical',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.primaryText.withValues(
                                        alpha: 0.85,
                                      ),
                                      fontSize: w * 0.025,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.7,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .shimmer(
                              duration: 1500.ms,
                              color: AppTheme.primaryText.withValues(
                                alpha: 0.2,
                              ),
                            ),
                      ],
                    ],
                  ),
                )
                .animate()
                .fade(duration: 600.ms)
                .slideY(begin: -0.15, duration: 600.ms),

            // ── BOTTOM legend ────────────────────────────────────────────
            Positioned(
                  bottom: w * 0.05,
                  left: w * 0.02,
                  right: w * 0.02,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.02,
                      vertical: w * 0.015,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.cardSurface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _legendDot(AppTheme.criticalRed, 'Critical', w),
                        _divider(),
                        _legendDot(AppTheme.warningAmber, 'Monitor', w),
                        _divider(),
                        _legendDot(AppTheme.safeGreen, 'Safe', w),
                        _divider(),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${sequences.length}',
                              style: GoogleFonts.outfit(
                                color: AppTheme.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.038,
                              ),
                            ),
                            Text(
                              'SIGNALS',
                              style: GoogleFonts.outfit(
                                color: AppTheme.secondaryText,
                                fontSize: w * 0.022,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .animate()
                .fade(delay: 200.ms, duration: 500.ms)
                .slideY(begin: 0.15, delay: 200.ms, duration: 500.ms),
          ],
        );
      }),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _legendDot(Color color, String label, double w) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: w * 0.022,
          height: w * 0.022,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
            ],
          ),
        ),
        SizedBox(width: w * 0.015),
        Text(
          label,
          style: GoogleFonts.outfit(
            color: AppTheme.primaryText,
            fontSize: w * 0.028,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 24, color: AppTheme.cardBorder);

  Marker _buildMarker(BuildContext context, SequenceModel seq, double w) {
    final score = seq.threatScore.combinedThreatIndex;
    final color = _threatColor(score);
    final isCritical = score >= 75;
    final label = seq.name.split(' ').first;

    return Marker(
      point: LatLng(seq.latitude, seq.longitude),
      width: w * 0.22,
      height: w * 0.06,
      child: GestureDetector(
        onTap: () => _showDetail(context, seq, color),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (isCritical)
                  Container(
                        width: w * 0.1,
                        height: w * 0.1,
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
                  width: w * 0.025,
                  height: w * 0.025,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.6),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: w * 0.01),
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.012,
                  vertical: w * 0.005,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: color.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
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
      ),
    );
  }

  void _showDetail(BuildContext context, SequenceModel seq, Color color) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: w * 0.05,
          right: w * 0.05,
          top: h * 0.02,
          bottom: MediaQuery.of(context).padding.bottom + w * 0.08,
        ),
        decoration: BoxDecoration(
          color: AppTheme.cardSurface.withValues(alpha: 0.97),
          borderRadius: BorderRadius.vertical(top: Radius.circular(w * 0.06)),
          border: const Border(
            top: BorderSide(color: AppTheme.cardBorder, width: 1.5),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: w * 0.1,
                height: h * 0.005,
                decoration: BoxDecoration(
                  color: AppTheme.secondaryText.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            SizedBox(height: h * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seq.name,
                        style: GoogleFonts.outfit(
                          color: AppTheme.primaryText,
                          fontSize: w * 0.052,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: h * 0.004),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppTheme.secondaryText,
                            size: w * 0.035,
                          ),
                          SizedBox(width: w * 0.01),
                          Text(
                            seq.originLocation,
                            style: GoogleFonts.outfit(
                              color: AppTheme.secondaryText,
                              fontSize: w * 0.033,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.045,
                    vertical: h * 0.012,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(w * 0.03),
                    border: Border.all(color: color),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${seq.threatScore.combinedThreatIndex}',
                        style: GoogleFonts.outfit(
                          color: color,
                          fontSize: w * 0.058,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '/ 100',
                        style: GoogleFonts.outfit(
                          color: color.withValues(alpha: 0.7),
                          fontSize: w * 0.026,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: h * 0.02),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: w * 0.025,
              ),
              decoration: BoxDecoration(
                color: AppTheme.background.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppTheme.infoBlue,
                    size: w * 0.042,
                  ),
                  SizedBox(width: w * 0.025),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detection Date',
                        style: GoogleFonts.outfit(
                          color: AppTheme.secondaryText,
                          fontSize: w * 0.027,
                        ),
                      ),
                      Text(
                        seq.detectionDate.toIso8601String().split('T').first,
                        style: GoogleFonts.outfit(
                          color: AppTheme.primaryText,
                          fontSize: w * 0.036,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
    );
  }
}
