import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../theme/app_theme.dart';
import '../../models/sequence_model.dart';

class AgentTimeline extends StatelessWidget {
  final List<AgentStepModel> steps;

  const AgentTimeline({super.key, required this.steps});

  Color _getColor(String colorName) {
    switch (colorName.toLowerCase()) {
      case 'red':
        return AppTheme.criticalRed;
      case 'purple':
        return AppTheme.purpleStructural;
      case 'green':
        return AppTheme.safeGreen;
      case 'blue':
      default:
        return AppTheme.infoBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) {
      return Center(
        child: Text(
          'No agent trace available.',
          style: GoogleFonts.outfit(color: AppTheme.secondaryText),
        ),
      );
    }

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        final isFirst = index == 0;
        final isLast = index == steps.length - 1;
        final color = _getColor(step.color);

        return TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          indicatorStyle: IndicatorStyle(
            width: w * 0.055,
            height: w * 0.055,
            indicator: Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Center(
                child: Container(
                  width: w * 0.018,
                  height: w * 0.018,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          beforeLineStyle: const LineStyle(
            color: AppTheme.cardBorder,
            thickness: 2,
          ),
          endChild: Padding(
            padding: EdgeInsets.only(left: w * 0.04, bottom: h * 0.03, top: h * 0.01),
            child: Container(
              padding: EdgeInsets.all(w * 0.04),
              decoration: AppTheme.glassDecoration.copyWith(
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        step.agent,
                        style: GoogleFonts.outfit(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.035,
                        ),
                      ),
                      Text(
                        step.timestamp.split(' ').first,
                        style: GoogleFonts.outfit(
                          color: AppTheme.mutedText,
                          fontSize: w * 0.025,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.01),
                  Text(
                    step.action,
                    style: GoogleFonts.outfit(
                      color: AppTheme.primaryText,
                      fontSize: w * 0.035,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
