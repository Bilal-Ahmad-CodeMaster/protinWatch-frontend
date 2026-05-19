import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/region_details.dart';
import '../../../theme/app_theme.dart';

/// The interactive sliding panel containing detailed statistics for selected protein domains.
class ProteinViewerDetailPanel extends StatelessWidget {
  final AnimationController panelController;
  final String? selectedRegion;
  final double webViewHeight;
  final VoidCallback onCloseDetail;
  final Function(String key) onSelectRegion;

  const ProteinViewerDetailPanel({
    super.key,
    required this.panelController,
    required this.selectedRegion,
    required this.webViewHeight,
    required this.onCloseDetail,
    required this.onSelectRegion,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return AnimatedBuilder(
      animation: panelController,
      builder: (context, child) {
        final activeDetails = regionDetailsMap[selectedRegion];
        if (activeDetails == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: panelController.value * webViewHeight,
          child: Container(
            decoration: const BoxDecoration(
              color: AppTheme.background,
              border: Border(
                top: BorderSide(color: AppTheme.cardBorder, width: 0.5),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(w * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Panel Header Row (Title and Dismiss button)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: w * 0.025,
                            height: w * 0.025,
                            decoration: BoxDecoration(
                              color: activeDetails.color,
                              borderRadius: BorderRadius.circular(w * 0.0075),
                            ),
                          ),
                          SizedBox(width: w * 0.015),
                          Text(
                            activeDetails.name,
                            style: GoogleFonts.outfit(
                              fontSize: w * 0.032,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.primaryText,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.close,
                          color: AppTheme.secondaryText,
                          size: w * 0.045,
                        ),
                        onPressed: onCloseDetail,
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.02),

                  // Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 2.3,
                    mainAxisSpacing: w * 0.015,
                    crossAxisSpacing: w * 0.015,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatCard("Chain", activeDetails.chain, w),
                      _buildStatCard("Residues", activeDetails.residues, w),
                      _buildStatCard("Atoms", activeDetails.atoms, w),
                      _buildStatCard(
                        "pLDDT",
                        activeDetails.plddt.toString(),
                        w,
                        label: 'pLDDT',
                      ),
                      _buildStatCard(
                        "Affinity",
                        activeDetails.affinity,
                        w,
                        label: 'Affinity',
                      ),
                      _buildStatCard(
                        "Risk Level",
                        activeDetails.risk,
                        w,
                        label: 'Risk',
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.025),

                  // Danger Score Bar
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Danger score",
                            style: GoogleFonts.outfit(
                              fontSize: w * 0.025,
                              color: AppTheme.secondaryText,
                            ),
                          ),
                          Text(
                            "${(activeDetails.dangerPercent * 100).toInt()}%",
                            style: GoogleFonts.outfit(
                              fontSize: w * 0.025,
                              color: activeDetails.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: w * 0.0125),
                      LayoutBuilder(
                        builder: (context, dangerConstraints) {
                          return Container(
                            height: w * 0.0125,
                            decoration: BoxDecoration(
                              color: AppTheme.cardBorder,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOut,
                              height: w * 0.0125,
                              width:
                                  activeDetails.dangerPercent *
                                  dangerConstraints.maxWidth,
                              decoration: BoxDecoration(
                                color: activeDetails.color,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.025),

                  // Description Box
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      border: Border.all(
                        color: AppTheme.cardBorder,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    padding: EdgeInsets.all(w * 0.02),
                    child: Text(
                      activeDetails.description,
                      style: GoogleFonts.outfit(
                        fontSize: w * 0.028,
                        color: AppTheme.secondaryText,
                        height: 1.5,
                      ),
                    ),
                  ),

                  // Region Switcher Buttons inside details panel
                  SizedBox(height: w * 0.025),
                  Wrap(
                    spacing: w * 0.015,
                    runSpacing: w * 0.015,
                    children: regionDetailsMap.entries.map((entry) {
                      final key = entry.key;
                      final details = entry.value;
                      final isSelected = selectedRegion == key;

                      return GestureDetector(
                        onTap: () => onSelectRegion(key),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.infoBlue.withValues(alpha: 0.15)
                                : AppTheme.cardSurface,
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.infoBlue
                                  : AppTheme.cardBorder,
                              width: 0.5,
                            ),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.025,
                            vertical: w * 0.01,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: w * 0.015,
                                height: w * 0.015,
                                decoration: BoxDecoration(
                                  color: details.color,
                                  borderRadius: BorderRadius.circular(
                                    w * 0.0075,
                                  ),
                                ),
                              ),
                              SizedBox(width: w * 0.0125),
                              Text(
                                key.toUpperCase(),
                                style: GoogleFonts.outfit(
                                  fontSize: w * 0.023,
                                  color: isSelected
                                      ? AppTheme.primaryText
                                      : AppTheme.secondaryText,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Stat card builder helper
  Widget _buildStatCard(
    String labelText,
    String valueText,
    double w, {
    String? label,
  }) {
    final valueColor = _getStatValueColor(valueText, label ?? labelText);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.background,
        border: Border.all(color: AppTheme.cardBorder, width: 0.5),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            labelText.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: w * 0.022,
              color: AppTheme.secondaryText,
              letterSpacing: 0.07,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: w * 0.005),
          Text(
            valueText,
            style: GoogleFonts.outfit(
              fontSize: w * 0.032,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Color mapping helper for stat cards
  Color _getStatValueColor(String value, String label) {
    final l = label.toLowerCase();
    final v = value.toLowerCase();

    if (l == 'affinity' || l == 'risk') {
      if (v == 'high' || v == 'critical') {
        return AppTheme.criticalRed;
      }
      if (v == 'medium' || v == 'moderate') {
        return AppTheme.warningAmber;
      }
      if (v == 'low' || v == 'stable' || v == 'safe') {
        return AppTheme.safeGreen;
      }
      return AppTheme.secondaryText;
    }

    if (l == 'plddt') {
      return AppTheme.warningAmber;
    }

    return AppTheme.secondaryText;
  }
}
