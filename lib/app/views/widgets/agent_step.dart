import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'dart:ui';
import '../../theme/app_theme.dart';
import '../../models/agent_trace_model.dart';

class AgentStep extends StatelessWidget {
  final AgentTraceModel trace;
  final bool isFirst;
  final bool isLast;

  const AgentStep({
    super.key,
    required this.trace,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = trace.status == 'warning'
        ? AppTheme.warningAmber
        : AppTheme.infoBlue;
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return TimelineTile(
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: IndicatorStyle(
        width: w * 0.05,
        color: color,
        padding: EdgeInsets.all(w * 0.02),
        iconStyle: IconStyle(
          iconData: Icons.memory,
          color: AppTheme.background,
          fontSize: w * 0.03,
        ),
      ),
      beforeLineStyle: LineStyle(
        color: color.withValues(alpha: 0.5),
        thickness: 3,
      ),
      afterLineStyle: LineStyle(
        color: color.withValues(alpha: 0.5),
        thickness: 3,
      ),
      endChild:
          Padding(
                padding: EdgeInsets.only(
                  left: w * 0.04,
                  bottom: h * 0.03,
                  top: h * 0.01,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(w * 0.04),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: AppTheme.glassDecoration.copyWith(
                        border: Border.all(color: color.withValues(alpha: 0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(w * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  trace.agentName,
                                  style: GoogleFonts.outfit(
                                    color: color,
                                    fontWeight: FontWeight.w800,
                                    fontSize: w * 0.04,
                                    letterSpacing: 1.1,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: w * 0.02),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: w * 0.02,
                                  vertical: h * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  trace.timestamp,
                                  style: GoogleFonts.outfit(
                                    color: AppTheme.secondaryText,
                                    fontSize: w * 0.025,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: h * 0.015),
                          Text(
                            trace.log,
                            style: GoogleFonts.outfit(
                              color: AppTheme.primaryText,
                              fontSize: w * 0.035,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            children: [
                              Icon(
                                Icons.speed,
                                size: w * 0.03,
                                color: AppTheme.safeGreen,
                              ),
                              SizedBox(width: w * 0.015),
                              Text(
                                'Execution Latency: ${trace.executionTimeMs}ms',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.safeGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.028,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fade(duration: const Duration(milliseconds: 600))
              .slideY(begin: 0.1, end: 0, curve: Curves.easeOutBack),
    );
  }
}
