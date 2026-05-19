import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class BriefDisplay extends StatelessWidget {
  final String text;
  final String language;

  const BriefDisplay({super.key, required this.text, required this.language});

  @override
  Widget build(BuildContext context) {
    final bool isUrdu = language == 'ur';
    final w = MediaQuery.sizeOf(context).width;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Directionality(
        textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
        child: Text(
          text,
          style: isUrdu
              ? GoogleFonts.notoNastaliqUrdu(
                  color: AppTheme.primaryText,
                  fontSize: w * 0.04,
                  height: 1.6,
                )
              : GoogleFonts.outfit(
                  color: AppTheme.primaryText,
                  fontSize: w * 0.038,
                  height: 1.6,
                ),
        ),
      ),
    );
  }
}
