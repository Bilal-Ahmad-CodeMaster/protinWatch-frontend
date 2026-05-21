import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../models/sequence_model.dart';

class ActionPanelTrace extends StatefulWidget {
  final String alertId;
  final List<AgentStepModel>? agentTrace;
  final int? threatIndex;

  const ActionPanelTrace({
    super.key,
    required this.alertId,
    this.agentTrace,
    this.threatIndex,
  });

  @override
  State<ActionPanelTrace> createState() => _ActionPanelTraceState();
}

class _ActionPanelTraceState extends State<ActionPanelTrace> {
  bool _isTraceExpanded = true;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAgentTraceHeader(w),
        _buildAgentTraceList(w),
      ],
    );
  }

  Widget _buildAgentTraceHeader(double w) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isTraceExpanded = !_isTraceExpanded;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: w * 0.025),
        decoration: BoxDecoration(
          color: AppTheme.background.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder),
        ),
        child: Row(
          children: [
            Icon(
              Icons.alt_route_rounded,
              color: AppTheme.secondaryText,
              size: w * 0.04,
            ),
            SizedBox(width: w * 0.02),
            Text(
              'Agent trace',
              style: GoogleFonts.outfit(
                color: AppTheme.primaryText,
                fontWeight: FontWeight.w600,
                fontSize: w * 0.032,
              ),
            ),
            SizedBox(width: w * 0.02),
            Container(
              padding: EdgeInsets.symmetric(horizontal: w * 0.015, vertical: w * 0.003),
              decoration: BoxDecoration(
                color: AppTheme.cardBorder,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_getTraceSteps().length} steps',
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.024,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Icon(
              _isTraceExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppTheme.secondaryText,
              size: w * 0.045,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentTraceList(double w) {
    final steps = _getTraceSteps();
    final score = widget.threatIndex ?? 91;
    return AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Container(
        margin: EdgeInsets.only(top: w * 0.02),
        padding: EdgeInsets.all(w * 0.03),
        decoration: BoxDecoration(
          color: AppTheme.background.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            ...List.generate(steps.length, (index) {
              final step = steps[index];
              final isLast = index == steps.length - 1;
              return _buildTraceStepItem(step, index + 1, isLast, w);
            }),
            if (score >= 50 && score <= 75) ...[
              SizedBox(height: w * 0.02),
              Container(
                padding: EdgeInsets.all(w * 0.03),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Text(
                      'ℹ️',
                      style: TextStyle(fontSize: w * 0.04),
                    ),
                    SizedBox(width: w * 0.02),
                    Expanded(
                      child: Text(
                        'Threat level does not require WHO notification or resource dispatch',
                        style: GoogleFonts.outfit(
                          color: Colors.grey[400],
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (score < 50) ...[
              SizedBox(height: w * 0.02),
              Container(
                padding: EdgeInsets.all(w * 0.03),
                decoration: BoxDecoration(
                  color: AppTheme.safeGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.safeGreen.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Text(
                      '✅',
                      style: TextStyle(fontSize: w * 0.04),
                    ),
                    SizedBox(width: w * 0.02),
                    Expanded(
                      child: Text(
                        'Sequence is safe. Monitoring continues normally.',
                        style: GoogleFonts.outfit(
                          color: AppTheme.safeGreen,
                          fontSize: w * 0.03,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      crossFadeState: _isTraceExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildTraceStepItem(AgentStepModel step, int num, bool isLast, double w) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: w * 0.055,
                height: w * 0.055,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.cardBorder, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '$num',
                    style: GoogleFonts.outfit(
                      color: AppTheme.secondaryText,
                      fontWeight: FontWeight.bold,
                      fontSize: w * 0.028,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppTheme.cardBorder),
                ),
            ],
          ),
          SizedBox(width: w * 0.03),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : w * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        step.agent,
                        style: GoogleFonts.outfit(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.032,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: w * 0.015,
                          vertical: w * 0.005,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.safeGreen.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppTheme.safeGreen.withValues(alpha: 0.3),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Done',
                          style: GoogleFonts.outfit(
                            color: AppTheme.safeGreen,
                            fontSize: w * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.005),
                  Text(
                    step.action,
                    style: GoogleFonts.outfit(
                      color: AppTheme.secondaryText,
                      fontSize: w * 0.028,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: w * 0.008),
                  Text(
                    step.timestamp,
                    style: GoogleFonts.outfit(
                      color: AppTheme.mutedText,
                      fontSize: w * 0.024,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<AgentStepModel> _getTraceSteps() {
    final score = widget.threatIndex ?? 91;
    if (score > 75) {
      return [
        AgentStepModel(
          agent: 'DetectionAgent',
          action: "Threat Index $score/100 - threshold exceeded",
          timestamp: '14:30:05 UTC - 0.4s',
          color: 'blue',
        ),
        AgentStepModel(
          agent: 'VerificationAgent',
          action: "AlphaFold structural confirmation checked",
          timestamp: '14:30:07 UTC - 1.2s',
          color: 'purple',
        ),
        AgentStepModel(
          agent: 'ResponseAgent',
          action: "Alert ${widget.alertId} created and dispatched",
          timestamp: '14:30:09 UTC - 0.1s',
          color: 'red',
        ),
        AgentStepModel(
          agent: 'NotificationAgent',
          action: "WHO + stakeholders notified",
          timestamp: '14:30:10 UTC - 0.2s',
          color: 'green',
        ),
      ];
    } else if (score >= 50) {
      return [
        AgentStepModel(
          agent: 'DetectionAgent',
          action: "Threat Index $score/100 - under critical threshold",
          timestamp: '14:30:05 UTC - 0.4s',
          color: 'blue',
        ),
        AgentStepModel(
          agent: 'MonitoringAgent',
          action: "Sequence added to surveillance watchlist. No immediate action required.",
          timestamp: '14:30:07 UTC - 0.8s',
          color: 'orange',
        ),
      ];
    } else {
      return [
        AgentStepModel(
          agent: 'DetectionAgent',
          action: "Threat Index $score/100 - classified as safe. No action required.",
          timestamp: '14:30:05 UTC - 0.4s',
          color: 'blue',
        ),
      ];
    }
  }
}
