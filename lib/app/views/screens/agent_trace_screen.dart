import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../controllers/sequence_controller.dart';
import '../widgets/action_panel/action_panel_actions.dart';

class AgentTraceScreen extends StatelessWidget {
  const AgentTraceScreen({super.key});

  void _shareReport(dynamic seq) {
    if (seq == null) return;

    final traceData = seq.agentTrace
        .map(
          (e) => {
            'agent': e.agent,
            'action': e.action,
            'timestamp': e.timestamp,
          },
        )
        .toList();

    final report = {
      'sequence_id': seq.id,
      'threat_index': seq.threatScore.combinedThreatIndex,
      'trace': traceData,
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(report);
    Share.share(jsonString, subject: 'ProteinWatch Trace Report - ${seq.id}');
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final SequenceController seqController = Get.find();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Agent Execution Trace',
                      style: GoogleFonts.outfit(
                        color: AppTheme.secondaryText,
                        fontSize: w * 0.045,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, color: AppTheme.infoBlue),
                      onPressed: () =>
                          _shareReport(seqController.selectedSequence.value),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final seq = seqController.selectedSequence.value;
                  if (seq == null || seq.agentTrace.isEmpty) {
                    return Center(
                      child: Text(
                        'No Agent Trace data available.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          color: AppTheme.secondaryText,
                          fontSize: w * 0.04,
                        ),
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: w * 0.02),
                        // Custom animated vertical timeline of agents
                        Column(
                          children: List.generate(seq.agentTrace.length, (
                            index,
                          ) {
                            final step = seq.agentTrace[index];
                            final isLast = index == seq.agentTrace.length - 1;
                            final stepNum = index + 1;

                            return IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Left side: Numbered indicator circle and connector line
                                      Column(
                                        children: [
                                          Container(
                                            width: w * 0.07,
                                            height: w * 0.07,
                                            decoration: BoxDecoration(
                                              color: AppTheme.background,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppTheme.cardBorder,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                '$stepNum',
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
                                              child: Container(
                                                width: 2.0,
                                                color: AppTheme.cardBorder,
                                              ),
                                            ),
                                        ],
                                      ),
                                      SizedBox(width: w * 0.04),
                                      // Right side: Agent name, status badge, details and timestamp
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: isLast ? 0.0 : w * 0.06,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    step.agent,
                                                    style: GoogleFonts.outfit(
                                                      color:
                                                          AppTheme.primaryText,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: w * 0.038,
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: w * 0.018,
                                                          vertical: w * 0.003,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                        color: AppTheme
                                                            .safeGreen
                                                            .withValues(
                                                              alpha: 0.4,
                                                            ),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      'Done',
                                                      style: GoogleFonts.outfit(
                                                        color:
                                                            AppTheme.safeGreen,
                                                        fontSize: w * 0.024,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: w * 0.01),
                                              Text(
                                                step.action,
                                                style: GoogleFonts.outfit(
                                                  color: AppTheme.secondaryText,
                                                  fontSize: w * 0.032,
                                                  height: 1.3,
                                                ),
                                              ),
                                              SizedBox(height: w * 0.01),
                                              Text(
                                                step.timestamp,
                                                style: GoogleFonts.outfit(
                                                  color: AppTheme.secondaryText
                                                      .withValues(alpha: 0.5),
                                                  fontSize: w * 0.028,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .animate()
                                .fade(
                                  duration: const Duration(milliseconds: 500),
                                  delay: Duration(milliseconds: index * 300),
                                )
                                .slideY(
                                  begin: 0.1,
                                  duration: const Duration(milliseconds: 500),
                                  delay: Duration(milliseconds: index * 300),
                                  curve: Curves.easeOutQuad,
                                );
                          }),
                        ),
                        Divider(
                              height: w * 0.08,
                              color: AppTheme.cardBorder,
                              thickness: 1.5,
                            )
                            .animate()
                            .fade(
                              duration: const Duration(milliseconds: 500),
                              delay: const Duration(milliseconds: 1200),
                            )
                            .slideY(
                              begin: 0.1,
                              duration: const Duration(milliseconds: 500),
                              delay: const Duration(milliseconds: 1200),
                              curve: Curves.easeOutQuad,
                            ),
                        // Actions Taken Boxes Section at the bottom of the trace
                        ActionPanelActions(alertId: seq.id)
                            .animate()
                            .fade(
                              duration: const Duration(milliseconds: 500),
                              delay: const Duration(milliseconds: 1400),
                            )
                            .slideY(
                              begin: 0.1,
                              duration: const Duration(milliseconds: 500),
                              delay: const Duration(milliseconds: 1400),
                              curve: Curves.easeOutQuad,
                            ),
                        SizedBox(height: w * 0.25),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
