import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/signal_model.dart';
import 'dart:ui';

class SignalItem extends StatelessWidget {
  final SignalModel signal;
  
  const SignalItem({super.key, required this.signal});

  Color _getColor() {
    switch (signal.type) {
      case 'social': return AppTheme.criticalRed;
      case 'weather': return AppTheme.infoBlue;
      case 'traffic': return AppTheme.warningAmber;
      case 'conflict': return AppTheme.conflictingPurple;
      default: return AppTheme.secondaryText;
    }
  }

  IconData _getIcon() {
    switch (signal.type) {
      case 'social': return Icons.radar;
      case 'weather': return Icons.cloud;
      case 'traffic': return Icons.directions_car;
      case 'conflict': return Icons.warning_amber_rounded;
      default: return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();
    final isConflict = signal.type == 'conflict';
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Container(
      margin: EdgeInsets.only(bottom: h * 0.02),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(w * 0.04),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: AppTheme.glassDecoration.copyWith(
              border: isConflict 
                  ? Border.all(color: AppTheme.conflictingPurple, width: 2) 
                  : Border.all(color: AppTheme.cardBorder),
            ),
            padding: EdgeInsets.all(w * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(w * 0.02),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: color.withValues(alpha: 0.3)),
                          ),
                          child: Icon(_getIcon(), size: w * 0.04, color: color),
                        ),
                        SizedBox(width: w * 0.03),
                        Text(
                          signal.source, 
                          style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.w700, letterSpacing: 1.1),
                        ),
                      ],
                    ),
                    Text(
                      signal.timeAgo, 
                      style: GoogleFonts.outfit(
                        color: AppTheme.secondaryText,
                        fontSize: w * 0.03,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h * 0.015),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(w * 0.03),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(w * 0.02),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: DefaultTextStyle(
                    style: GoogleFonts.sourceCodePro(
                      color: AppTheme.primaryText,
                      fontSize: w * 0.035,
                      height: 1.4,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          signal.content, 
                          speed: const Duration(milliseconds: 30),
                          cursor: '█',
                        )
                      ],
                      isRepeatingAnimation: false,
                      displayFullTextOnTap: true,
                    ),
                  ),
                ),
                SizedBox(height: h * 0.015),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.verified, size: w * 0.035, color: color.withValues(alpha: 0.7)),
                        SizedBox(width: w * 0.015),
                        Text(
                          'Confidence: ${signal.confidence}%', 
                          style: GoogleFonts.outfit(
                            color: AppTheme.secondaryText,
                            fontSize: w * 0.03,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.005),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        signal.credibility.toUpperCase(),
                        style: GoogleFonts.outfit(color: color, fontWeight: FontWeight.w800, letterSpacing: 1),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(duration: const Duration(milliseconds: 500)).slideY(begin: 0.1, end: 0, curve: Curves.easeOutExpo);
  }
}
