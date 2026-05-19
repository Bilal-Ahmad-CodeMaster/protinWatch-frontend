import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// Top bar component for the Protein Viewer, displaying name and confidence level.
class ProteinViewerTopBar extends StatelessWidget {
  final String? proteinName;
  final AnimationController pulseController;
  final Animation<double> pulseScale;
  final Animation<double> pulseOpacity;

  const ProteinViewerTopBar({
    super.key,
    required this.proteinName,
    required this.pulseController,
    required this.pulseScale,
    required this.pulseOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Pill displaying Protein Name and Pulsing Dot
          Container(
            decoration: BoxDecoration(
              color: AppTheme.background,
              border: Border.all(color: AppTheme.cardBorder, width: 0.5),
              borderRadius: BorderRadius.circular(999),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.025,
              vertical: w * 0.01,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: pulseController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: pulseOpacity.value,
                      child: Transform.scale(
                        scale: pulseScale.value,
                        child: Container(
                          width: w * 0.015,
                          height: w * 0.015,
                          decoration: BoxDecoration(
                            color: AppTheme.infoBlue,
                            borderRadius: BorderRadius.circular(w * 0.0075),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(width: w * 0.012),
                Text(
                  proteinName ?? 'Betacoronavirus Glycoprotein',
                  style: GoogleFonts.outfit(
                    fontSize: w * 0.026,
                    color: AppTheme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          // Right Pill displaying Confidence Score
          Container(
            decoration: BoxDecoration(
              color: AppTheme.safeGreen.withValues(alpha: 0.1),
              border: Border.all(
                color: AppTheme.safeGreen.withValues(alpha: 0.3),
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(999),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: w * 0.025,
              vertical: w * 0.01,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: w * 0.03,
                  color: AppTheme.safeGreen,
                ),
                SizedBox(width: w * 0.01),
                Text(
                  "72% conf",
                  style: GoogleFonts.outfit(
                    fontSize: w * 0.026,
                    color: AppTheme.safeGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
