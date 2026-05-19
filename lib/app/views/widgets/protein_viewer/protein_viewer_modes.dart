import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

/// The representation mode selector row (Ball+Stick, Ribbon, Surface, Wireframe).
class ProteinViewerModes extends StatelessWidget {
  final String selectedMode;
  final Function(String mode) onSetRepresentation;

  const ProteinViewerModes({
    super.key,
    required this.selectedMode,
    required this.onSetRepresentation,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.cardBorder, width: 0.5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: w * 0.015),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ['Ball+Stick', 'Ribbon', 'Surface', 'Wireframe'].map((
            mode,
          ) {
            final isSelected =
                selectedMode.toLowerCase() ==
                (mode == 'Ball+Stick' ? 'ball' : mode.toLowerCase());
            return GestureDetector(
              onTap: () => onSetRepresentation(
                mode == 'Ball+Stick' ? 'ball' : mode.toLowerCase(),
              ),
              child: Container(
                margin: EdgeInsets.only(right: w * 0.015),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.infoBlue : AppTheme.cardSurface,
                  border: Border.all(
                    color: isSelected ? AppTheme.infoBlue : AppTheme.cardBorder,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: w * 0.0125,
                ),
                child: Text(
                  mode,
                  style: GoogleFonts.outfit(
                    fontSize: w * 0.028,
                    color: isSelected
                        ? AppTheme.primaryText
                        : AppTheme.secondaryText,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
