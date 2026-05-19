import 'package:crio_app/app/views/screens/alert_screen_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../controllers/threat_controller.dart';
import '../../controllers/sequence_controller.dart';
import '../../models/sequence_model.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThreatController threatController = Get.find();
    final SequenceController sequenceController =
        Get.find<SequenceController>();
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: w * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alert History',
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ).animate().fade().slideY(begin: -0.2),
              Text(
                'Sorted by threat · last 50 analyses',
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.03,
                  fontWeight: FontWeight.w400,
                ),
              ).animate().fade().slideY(begin: -0.2),
              SizedBox(height: w * 0.02),
              Expanded(
                child: Obx(() {
                  final List<SequenceModel> alerts = sequenceController.sequences.isEmpty
                      ? threatController.history
                      : sequenceController.sequences;

                  return ListView.builder(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + w * 0.2,
                    ),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      final score = alert.threatScore.combinedThreatIndex;
                      final color = score >= 75
                          ? AppTheme.criticalRed
                          : (score >= 50
                                ? AppTheme.warningAmber
                                : AppTheme.safeGreen);

                      return GestureDetector(
                            onTap: () {
                              Get.to(() => AlertDetailsPage(alert: alert));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: w * 0.03),
                              padding: EdgeInsets.symmetric(
                                horizontal: w * 0.04,
                                vertical: w * 0.02,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.cardSurface.withValues(
                                  alpha: 0.9,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: color.withValues(alpha: 0.35),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 1. Header row
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              alert.name,
                                              style: GoogleFonts.outfit(
                                                color: AppTheme.primaryText,
                                                fontWeight: FontWeight.bold,
                                                fontSize: w * 0.04,
                                              ),
                                            ),
                                            SizedBox(height: w * 0.005),
                                            Text(
                                              '${alert.originLocation} · ${DateFormat('MMM dd yyyy').format(alert.detectionDate)}',
                                              style: GoogleFonts.outfit(
                                                color: AppTheme.secondaryText,
                                                fontSize: w * 0.03,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '$score',
                                          style: GoogleFonts.outfit(
                                            color: color,
                                            fontWeight: FontWeight.bold,
                                            fontSize: w * 0.05,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: '/100',
                                              style: GoogleFonts.outfit(
                                                color: AppTheme.primaryText
                                                    .withValues(alpha: 0.7),
                                                fontWeight: FontWeight.w500,
                                                fontSize: w * 0.035,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  // 2. Metrics (Progress bars) - only for Critical or Monitor
                                  if (score >= 50) ...[
                                    SizedBox(height: w * 0.02),
                                    _buildMetricRow(
                                      w,
                                      label: 'K-mer',
                                      value: alert.threatScore.kmerScore,
                                      color: AppTheme.infoBlue,
                                    ),
                                    SizedBox(height: w * 0.01),
                                    _buildMetricRow(
                                      w,
                                      label: 'ESM-2',
                                      value: alert.threatScore.esm2Score,
                                      color: color,
                                    ),
                                  ],

                                  SizedBox(height: w * 0.02),
                                  _buildStatusBadge(w, alert, score),
                                ],
                              ),
                            ),
                          )
                          .animate()
                          .fade(delay: Duration(milliseconds: 100 * index))
                          .slideY(begin: 0.1);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricRow(
    double w, {
    required String label,
    required int value,
    required Color color,
  }) {
    return Row(
      children: [
        SizedBox(
          width: w * 0.14,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: AppTheme.secondaryText,
              fontSize: w * 0.032,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              backgroundColor: AppTheme.background,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        SizedBox(width: w * 0.04),
        SizedBox(
          width: w * 0.06,
          child: Text(
            '$value',
            style: GoogleFonts.outfit(
              color: color,
              fontSize: w * 0.032,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(double w, SequenceModel alert, int score) {
    String text = '';
    Color color = Colors.transparent;

    if (score >= 75) {
      final alertId = alert.alert?.alertId ?? 'PW-2019-001';
      text = 'ALERT DISPATCHED · $alertId';
      color = AppTheme.criticalRed;
    } else if (score >= 50) {
      text = 'MONITORING — no action';
      color = AppTheme.safeGreen;
    } else {
      text = 'SAFE — no action required';
      color = AppTheme.safeGreen;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.01),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: color,
          fontSize: w * 0.024,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
