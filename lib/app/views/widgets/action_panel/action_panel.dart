import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/sequence_model.dart';
import 'action_panel_header.dart';
import 'action_panel_scores.dart';
import 'action_panel_actions.dart';
import 'action_panel_trace.dart';

class ActionPanelWidget extends StatelessWidget {
  final bool isActive;
  final String alertId;
  final int? threatIndex;
  final int? kmerScore;
  final int? esm2Score;
  final double? structuralScore;
  final String? virusName;
  final String? sequenceName;
  final String? uniprotId;
  final List<AgentStepModel>? agentTrace;

  const ActionPanelWidget({
    super.key,
    required this.isActive,
    this.alertId = 'ALT-20191226-001',
    this.threatIndex,
    this.kmerScore,
    this.esm2Score,
    this.structuralScore,
    this.virusName,
    this.sequenceName,
    this.uniprotId,
    this.agentTrace,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) =>
          FadeTransition(opacity: animation, child: child),
      child: isActive ? _buildAfterState(w) : _buildBeforeState(w),
    );
  }

  Widget _buildBeforeState(double w) {
    return Container(
      key: const ValueKey('before'),
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shield_outlined,
            color: AppTheme.safeGreen,
            size: w * 0.05,
          ),
          SizedBox(width: w * 0.02),
          Expanded(
            child: Text(
              isActive
                  ? 'Active biological crisis alert.'
                  : 'No active biological crisis alerts. System monitoring.',
              style: GoogleFonts.outfit(
                color: AppTheme.secondaryText,
                fontSize: w * 0.032,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAfterState(double w) {
    return Container(
      key: const ValueKey('after'),
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.criticalRed.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.criticalRed.withValues(alpha: 0.04),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionPanelHeader(
            alertId: alertId,
            virusName: virusName,
            sequenceName: sequenceName,
            uniprotId: uniprotId,
            threatIndex: threatIndex,
          ),
          Divider(height: w * 0.06, color: AppTheme.cardBorder, thickness: 1.5),
          ActionPanelScores(
            kmerScore: kmerScore,
            esm2Score: esm2Score,
            structuralScore: structuralScore,
          ),
          Divider(height: w * 0.06, color: AppTheme.cardBorder, thickness: 1.5),
          ActionPanelActions(alertId: alertId),
          Divider(height: w * 0.06, color: AppTheme.cardBorder, thickness: 1.5),
          ActionPanelTrace(alertId: alertId, agentTrace: agentTrace),
        ],
      ),
    );
  }
}
