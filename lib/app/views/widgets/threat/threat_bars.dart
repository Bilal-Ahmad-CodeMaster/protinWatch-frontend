import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ThreatBars extends StatelessWidget {
  final int kmerScore;
  final int esm2Score;
  final double structuralScore;

  const ThreatBars({
    super.key,
    required this.kmerScore,
    required this.esm2Score,
    required this.structuralScore,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final labelWidth = w * 0.22;
    return Column(
      children: [
        _buildBar(
          'K-mer Novelty',
          kmerScore / 100,
          AppTheme.infoBlue,
          labelWidth,
        ),
        const SizedBox(height: 12),
        _buildBar(
          'ESM-2 Danger',
          esm2Score / 100,
          AppTheme.warningAmber,
          labelWidth,
        ),
        const SizedBox(height: 12),
        _buildBar(
          'AlphaFold Match',
          structuralScore,
          AppTheme.purpleStructural,
          labelWidth,
        ),
      ],
    );
  }

  Widget _buildBar(
    String label,
    double percentage,
    Color color,
    double labelWidth,
  ) {
    return Row(
      children: [
        SizedBox(
          width: labelWidth,
          child: Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              color: AppTheme.secondaryText,
              fontSize: labelWidth * 0.14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.cardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage.clamp(0.0, 1.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  )
                  .animate(target: percentage > 0 ? 1 : 0)
                  .scaleX(alignment: Alignment.centerLeft),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: labelWidth * 0.35,
          child: Text(
            '${(percentage * 100).toInt()}%',
            style: GoogleFonts.outfit(
              color: color,
              fontSize: labelWidth * 0.14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
