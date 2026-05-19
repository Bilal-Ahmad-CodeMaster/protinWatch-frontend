import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../controllers/threat_controller.dart';
import '../../../controllers/sequence_controller.dart';
import 'threat_bars.dart';

class ThreatCard extends StatelessWidget {
  const ThreatCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThreatController threatController = Get.find();
    final SequenceController sequenceController = Get.find();
    final w = MediaQuery.of(context).size.width;

    return Obx(() {
      final seq = sequenceController.selectedSequence.value;
      if (seq == null) {
        return const SizedBox.shrink();
      }

      final score = threatController.threatIndex.value;
      final esm2 = threatController.esm2Score.value;
      final Color statusColor = (score >= 75 || esm2 >= 61)
          ? AppTheme.criticalRed
          : (score >= 50 ? AppTheme.warningAmber : AppTheme.safeGreen);

      return Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
        decoration: BoxDecoration(
          color: AppTheme.cardSurface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: statusColor.withValues(alpha: (score >= 75 || esm2 >= 61) ? 0.2 : 0.05),
              blurRadius: 4,
              spreadRadius: -10,
            ),
            BoxShadow(
              color: AppTheme.cardSurface.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.biotech,
                            color: statusColor,
                            size: w * 0.05,
                          ),
                          SizedBox(width: w * 0.01),
                          Text(
                            'SEQ: ${seq.id}',
                            style: GoogleFonts.outfit(
                              color: statusColor,
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: w * 0.01),
                      Text(
                        seq.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          color: AppTheme.primaryText,
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.02,
                    vertical: w * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                      width: w * 0.002,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withValues(alpha: 0.2),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$score',
                        style: GoogleFonts.outfit(
                          color: statusColor,
                          fontSize: w * 0.05,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: w * 0.005),
                      Text(
                        '/100',
                        style: GoogleFonts.outfit(
                          color: statusColor.withValues(alpha: 0.7),
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: w * 0.025),
            ThreatBars(
              kmerScore: threatController.kmerScore.value,
              esm2Score: threatController.esm2Score.value,
              structuralScore: threatController.structuralScore.value,
            ),
            SizedBox(height: w * 0.001),
          ],
        ),
      );
    });
  }
}
