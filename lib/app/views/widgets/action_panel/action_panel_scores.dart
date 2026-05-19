import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ActionPanelScores extends StatelessWidget {
  final int? kmerScore;
  final int? esm2Score;
  final double? structuralScore;

  const ActionPanelScores({
    super.key,
    this.kmerScore,
    this.esm2Score,
    this.structuralScore,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Layers',
          style: GoogleFonts.outfit(
            color: AppTheme.secondaryText.withValues(alpha: 0.7),
            fontWeight: FontWeight.bold,
            fontSize: w * 0.028,
            letterSpacing: 1.2,
          ),
        ),
        SizedBox(height: w * 0.025),
        _buildScoreBarRow(
          'K-mer novelty',
          (kmerScore ?? 73).toDouble(),
          100,
          AppTheme.infoBlue,
          w,
        ),
        SizedBox(height: w * 0.02),
        _buildScoreBarRow(
          'ESM-2 danger',
          (esm2Score ?? 91).toDouble(),
          100,
          AppTheme.criticalRed,
          w,
        ),
        SizedBox(height: w * 0.02),
        _buildScoreBarRow(
          'Structural TM',
          structuralScore ?? 0.84,
          1.0,
          AppTheme.warningAmber,
          w,
          isTm: true,
        ),
      ],
    );
  }

  Widget _buildScoreBarRow(
    String label,
    double value,
    double maxVal,
    Color color,
    double w, {
    bool isTm = false,
  }) {
    final progressVal = (value / maxVal).clamp(0.0, 1.0);
    final valueText = isTm
        ? '${value.toStringAsFixed(2)} TM'
        : '${value.toInt()} / 100';

    return Row(
      children: [
        SizedBox(
          width: w * 0.22,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: AppTheme.secondaryText,
              fontSize: w * 0.03,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressVal,
              minHeight: 6,
              backgroundColor: AppTheme.background,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        SizedBox(width: w * 0.04),
        SizedBox(
          width: w * 0.15,
          child: Text(
            valueText,
            style: GoogleFonts.outfit(
              color: color,
              fontSize: w * 0.03,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
