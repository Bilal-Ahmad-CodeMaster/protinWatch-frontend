import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ActionPanelHeader extends StatelessWidget {
  final String alertId;
  final String? virusName;
  final String? sequenceName;
  final String? uniprotId;
  final int? threatIndex;

  const ActionPanelHeader({
    super.key,
    required this.alertId,
    this.virusName,
    this.sequenceName,
    this.uniprotId,
    this.threatIndex,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      alertId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        color: AppTheme.primaryText,
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  _buildDispatchedBadge(w),
                ],
              ),
              SizedBox(height: w * 0.015),
              Row(
                children: [
                  Icon(
                    Icons.coronavirus_outlined,
                    color: AppTheme.criticalRed,
                    size: w * 0.04,
                  ),
                  SizedBox(width: w * 0.015),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: virusName ?? 'SARS-CoV-2',
                        style: GoogleFonts.outfit(
                          color: AppTheme.criticalRed,
                          fontWeight: FontWeight.w600,
                          fontSize: w * 0.028,
                        ),
                        children: [
                          TextSpan(
                            text:
                                '  •  ${sequenceName ?? "Spike protein novel sequence"}  •  ${uniprotId ?? "UniProt P0DTC2"}',
                            style: GoogleFonts.outfit(
                              color: AppTheme.secondaryText,
                              fontWeight: FontWeight.w400,
                              fontSize: w * 0.028,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildThreatIndexCard(w),
            SizedBox(height: w * 0.015),
            _buildCriticalBadge(w),
          ],
        ),
      ],
    );
  }

  Widget _buildDispatchedBadge(double w) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.005),
      decoration: BoxDecoration(
        color: AppTheme.safeGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.safeGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: w * 0.015,
            height: w * 0.015,
            decoration: const BoxDecoration(
              color: AppTheme.safeGreen,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: w * 0.012),
          Text(
            'DISPATCHED',
            style: GoogleFonts.outfit(
              color: AppTheme.safeGreen,
              fontWeight: FontWeight.bold,
              fontSize: w * 0.025,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreatIndexCard(double w) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: w * 0.01),
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border.all(color: AppTheme.criticalRed.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${threatIndex ?? 91}',
            style: GoogleFonts.outfit(
              color: AppTheme.criticalRed,
              fontWeight: FontWeight.w800,
              fontSize: w * 0.05,
              height: 1.1,
            ),
          ),
          Text(
            'THREAT INDEX',
            style: GoogleFonts.outfit(
              color: AppTheme.criticalRed,
              fontWeight: FontWeight.w700,
              fontSize: w * 0.018,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalBadge(double w) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.015),
      decoration: BoxDecoration(
        color: AppTheme.criticalRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.criticalRed.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.criticalRed,
            size: w * 0.03,
          ),
          SizedBox(width: w * 0.01),
          Text(
            'CRITICAL',
            style: GoogleFonts.outfit(
              color: AppTheme.criticalRed,
              fontWeight: FontWeight.bold,
              fontSize: w * 0.025,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
