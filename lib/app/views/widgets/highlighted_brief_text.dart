import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class HighlightedBriefText extends StatelessWidget {
  final String text;
  final double w;
  final bool isUrdu;

  const HighlightedBriefText({
    super.key,
    required this.text,
    required this.w,
    this.isUrdu = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isUrdu) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: SelectableText(
          text,
          style: GoogleFonts.notoNastaliqUrdu(
            color: AppTheme.primaryText,
            fontSize: w * 0.035,
            height: 1.8,
          ),
        ),
      );
    }

    // Regex to split by section headers
    final regExp = RegExp(
      r'(SITUATION:|THREAT LEVEL:|WHY DANGEROUS:|RECOMMENDED ACTIONS:)',
      caseSensitive: true,
    );

    final matches = regExp.allMatches(text).toList();
    if (matches.isEmpty) {
      // If no section headers, just return a single block with highlighted text
      return SelectableText.rich(
        TextSpan(
          children: _parseKeywords(text, w),
        ),
      );
    }

    final List<Widget> sections = [];

    // If there's some text before the first section header, add it
    if (matches.first.start > 0) {
      final leadingText = text.substring(0, matches.first.start).trim();
      if (leadingText.isNotEmpty) {
        sections.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SelectableText.rich(
              TextSpan(
                children: _parseKeywords(leadingText, w),
              ),
            ),
          ),
        );
      }
    }

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final header = match.group(0)!;
      final startOfContent = match.end;
      final endOfContent = (i + 1 < matches.length) ? matches[i + 1].start : text.length;
      final content = text.substring(startOfContent, endOfContent).trim();

      sections.add(
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.only(left: 12),
          decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(
                color: AppTheme.safeGreen, // subtle left green border line
                width: 3.5,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                header,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.038, // slightly larger font
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              SelectableText.rich(
                TextSpan(
                  children: _parseKeywords(content, w),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections,
    );
  }

  List<TextSpan> _parseKeywords(String text, double w) {
    final List<TextSpan> spans = [];
    
    // Regular expression matching:
    // Group 1: Threat levels (CRITICAL, HIGH, MEDIUM, LOW)
    // Group 2: Numbers & Percentages (e.g., 91%, 73%, etc.)
    // Group 3: Virus names (coronavirus, betacoronavirus, SARS, COVID, H5N1, MERS, SARS-CoV-2)
    // Group 4: Action words (IMMEDIATE, URGENT, ALERT, WARNING, NOTIFY)
    // Group 5: Location names (Wuhan, China, Geneva, Switzerland, USA, US)
    final keywordRegex = RegExp(
      r'(\b(?:CRITICAL|HIGH|MEDIUM|LOW)\b)|'
      r'(\b\d+(?:\.\d+)?%?\b|\b\d+%\b)|'
      r'(\b(?:coronavirus|betacoronavirus|SARS|COVID|H5N1|MERS|SARS-CoV-2|SARS-CoV)\b)|'
      r'(\b(?:IMMEDIATE|URGENT|ALERT|WARNING|NOTIFY)\b)|'
      r'(\b(?:Wuhan|China|Geneva|Switzerland|USA|US)\b)',
      caseSensitive: false,
    );

    int lastIndex = 0;
    final matches = keywordRegex.allMatches(text);
    
    for (final match in matches) {
      // Add text before match
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: text.substring(lastIndex, match.start),
          style: GoogleFonts.outfit(
            color: AppTheme.secondaryText,
            fontSize: w * 0.032,
            height: 1.5,
          ),
        ));
      }

      final matchedText = match.group(0)!;
      TextStyle style;

      // Group 1: Threat levels
      if (match.group(1) != null) {
        final upper = matchedText.toUpperCase();
        Color c;
        if (upper == 'CRITICAL') {
          c = AppTheme.criticalRed;
        } else if (upper == 'HIGH') {
          c = Colors.orange;
        } else if (upper == 'MEDIUM') {
          c = Colors.yellow;
        } else {
          c = AppTheme.safeGreen;
        }
        style = GoogleFonts.outfit(
          color: c,
          fontWeight: FontWeight.bold,
          fontSize: w * 0.032,
        );
      }
      // Group 2: Numbers & Percentages
      else if (match.group(2) != null) {
        style = GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: w * 0.032,
        );
      }
      // Group 3: Viruses
      else if (match.group(3) != null) {
        style = GoogleFonts.outfit(
          color: Colors.cyan,
          fontWeight: FontWeight.w600,
          fontSize: w * 0.032,
        );
      }
      // Group 4: Action words
      else if (match.group(4) != null) {
        style = GoogleFonts.outfit(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: w * 0.032,
        );
      }
      // Group 5: Locations
      else if (match.group(5) != null) {
        style = GoogleFonts.outfit(
          color: const Color(0xFF90CAF9), // light blue
          fontWeight: FontWeight.w500,
          fontSize: w * 0.032,
        );
      } else {
        style = GoogleFonts.outfit(
          color: AppTheme.primaryText,
          fontSize: w * 0.032,
        );
      }

      spans.add(TextSpan(
        text: matchedText,
        style: style,
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastIndex),
        style: GoogleFonts.outfit(
          color: AppTheme.secondaryText,
          fontSize: w * 0.032,
          height: 1.5,
        ),
      ));
    }

    return spans;
  }
}
