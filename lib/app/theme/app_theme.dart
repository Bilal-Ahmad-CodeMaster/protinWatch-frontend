import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - ProteinWatch Theme
  static const Color background = Color(0xFF0D0F14);
  static const Color cardSurface = Color(0xFF151820);
  static const Color cardBorder = Color(0xFF1E2230);

  // Status Colors
  static const Color criticalRed = Color(0xFFE84A4A);
  static const Color warningAmber = Color(0xFFF5A623);
  static const Color safeGreen = Color(0xFF4CAF74);
  static const Color infoBlue = Color(0xFF4A90D9);
  static const Color purpleStructural = Color(0xFF9B59B6);
  static const Color conflictingPurple = purpleStructural;

  // Text Colors
  static const Color primaryText = Color(0xFFE8EAF0);
  static const Color secondaryText = Color(0xFF8892A0);
  static const Color mutedText = Color(0xFF5A6270);

  static const String fontFamily = 'Outfit';

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: infoBlue,
      fontFamily: fontFamily,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: primaryText,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
        titleLarge: TextStyle(
          color: primaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(color: primaryText, fontSize: 16),
        bodyMedium: TextStyle(color: secondaryText, fontSize: 14),
        bodySmall: TextStyle(color: mutedText, fontSize: 12),
      ),
      colorScheme: const ColorScheme.dark(
        primary: infoBlue,
        secondary: warningAmber,
        surface: cardSurface,
        error: criticalRed,
      ),
    );
  }

  // Premium Glassmorphic Decoration for high-end cards
  static BoxDecoration get glassDecoration => BoxDecoration(
    color: cardSurface,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: cardBorder, width: 1.5),
    boxShadow: [
      BoxShadow(
        color: AppTheme.background.withValues(alpha: 0.4),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
      // Subtle inner glow highlight
      BoxShadow(
        color: AppTheme.primaryText.withValues(alpha: 0.03),
        blurRadius: 0,
        spreadRadius: 1,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
