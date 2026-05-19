import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ThreatScoreCard extends StatelessWidget {
  final double threatIndex;
  final double kmerScore;
  final double esm2Score;
  final double structuralScore;

  const ThreatScoreCard({
    super.key,
    required this.threatIndex,
    required this.kmerScore,
    required this.esm2Score,
    required this.structuralScore,
  });

  @override
  Widget build(BuildContext context) {
    final Color statusColor = (threatIndex >= 75 || (esm2Score * 100) >= 61)
        ? AppTheme.criticalRed
        : (threatIndex >= 50 ? AppTheme.warningAmber : AppTheme.safeGreen);
    final w = MediaQuery.sizeOf(context).width;

    return Card(
      elevation: 2,
      color: AppTheme.cardSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(w * 0.04),
        side: BorderSide(color: statusColor.withValues(alpha: 0.5), width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: w * 0.02, horizontal: w * 0.03),
        child: Column(
          children: [
            Text(
              '${threatIndex.toInt()}',
              style: GoogleFonts.outfit(
                fontSize: w * 0.1,
                fontWeight: FontWeight.w800,
                color: statusColor,
              ),
            ),
            Text(
              'Combined Threat Index',
              style: GoogleFonts.outfit(
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w600,
                fontSize: w * 0.04,
              ),
            ),
            SizedBox(height: w * 0.03),
            Row(
              children: [
                _buildAnimatedProgress(
                  'K-mer',
                  kmerScore,
                  AppTheme.infoBlue,
                  w,
                ),
                SizedBox(width: w * 0.02),
                _buildAnimatedProgress(
                  'ESM-2',
                  esm2Score,
                  AppTheme.warningAmber,
                  w,
                ),
                SizedBox(width: w * 0.02),
                _buildAnimatedProgress(
                  'Structural',
                  structuralScore,
                  AppTheme.purpleStructural,
                  w,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedProgress(
    String label,
    double value,
    Color color,
    double w,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: AppTheme.secondaryText,
              fontSize: w * 0.03,
            ),
          ),
          SizedBox(height: w * 0.01),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: value),
            duration: const Duration(milliseconds: 600),
            builder: (context, val, _) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: val,
                    backgroundColor: AppTheme.cardBorder,
                    color: color,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(val * 100).toInt()}%',
                    style: GoogleFonts.outfit(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.03,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
