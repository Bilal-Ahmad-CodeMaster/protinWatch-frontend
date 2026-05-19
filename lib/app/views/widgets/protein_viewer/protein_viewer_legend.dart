import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/region_details.dart';
import '../../../theme/app_theme.dart';

/// The color-coded legend display listing and selecting different protein domains.
class ProteinViewerLegend extends StatelessWidget {
  final String? selectedRegion;
  final Function(String key) onSelectRegion;

  const ProteinViewerLegend({
    super.key,
    required this.selectedRegion,
    required this.onSelectRegion,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.cardBorder, width: 0.5)),
      ),
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: w * 0.015),
      width: double.infinity,
      child: Wrap(
        spacing: w * 0.02,
        runSpacing: w * 0.01,
        children: regionDetailsMap.entries.map((entry) {
          final key = entry.key;
          final details = entry.value;
          final isSelected = selectedRegion == key;

          return GestureDetector(
            onTap: () => onSelectRegion(key),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: w * 0.022,
                  height: w * 0.022,
                  decoration: BoxDecoration(
                    color: details.color,
                    borderRadius: BorderRadius.circular(w * 0.0075),
                  ),
                ),
                SizedBox(width: w * 0.0125),
                Text(
                  key == 'rbd'
                      ? 'RBD'
                      : key == 'helix'
                      ? 'α-Helix'
                      : key == 'loop'
                      ? 'Loop'
                      : 'TM domain',
                  style: GoogleFonts.outfit(
                    fontSize: w * 0.028,
                    color: isSelected
                        ? AppTheme.primaryText
                        : AppTheme.secondaryText,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
