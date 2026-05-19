import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Region Details Data Model
class RegionDetails {
  final String name;
  final String chain;
  final String residues;
  final String atoms;
  final double plddt;
  final String affinity;
  final String risk;
  final Color color;
  final double dangerPercent;
  final String description;

  const RegionDetails({
    required this.name,
    required this.chain,
    required this.residues,
    required this.atoms,
    required this.plddt,
    required this.affinity,
    required this.risk,
    required this.color,
    required this.dangerPercent,
    required this.description,
  });
}

// Region selection models mapping
const Map<String, RegionDetails> regionDetailsMap = {
  'rbd': RegionDetails(
    name: 'Receptor Binding Domain (RBD)',
    chain: 'A',
    residues: '319–541',
    atoms: '1847',
    plddt: 68.4,
    affinity: 'High',
    risk: 'Critical',
    color: Color(0xffef4444),
    dangerPercent: 0.91,
    description:
        'Primary binding interface with human ACE2 receptor. High structural novelty detected. Immediate containment focus.',
  ),
  'helix': RegionDetails(
    name: 'α-Helix Backbone',
    chain: 'B',
    residues: '12–89',
    atoms: '624',
    plddt: 84.1,
    affinity: 'Low',
    risk: 'Stable',
    color: Color(0xff2563eb),
    dangerPercent: 0.18,
    description:
        'Stable structural scaffold. No significant divergence from reference strains. Standard monitoring applies.',
  ),
  'loop': RegionDetails(
    name: 'Flexible Loop Region',
    chain: 'A',
    residues: '220–318',
    atoms: '412',
    plddt: 52.7,
    affinity: 'Medium',
    risk: 'Moderate',
    color: Color(0xfff59e0b),
    dangerPercent: 0.57,
    description:
        'Flexible linker region between RBD and helix. Moderate novelty. Structural flexibility may affect transmissibility.',
  ),
  'tm': RegionDetails(
    name: 'Transmembrane Domain (TM)',
    chain: 'C',
    residues: '550–620',
    atoms: '389',
    plddt: 79.3,
    affinity: 'Low',
    risk: 'Low',
    color: Color(0xff7c3aed),
    dangerPercent: 0.22,
    description:
        'Membrane anchor region. Conserved across known strains. No anomalous structural features detected.',
  ),
};

// Mapping of NGL PDB selections
const Map<String, String> regionSelections = {
  'rbd': '319-541',
  'helix': '12-89',
  'loop': '220-318',
  'tm': '550-620',
};

/// A highly polished, self-contained pulsing dot widget to clean up the parent widget's animation logic.
class PulsingDot extends StatefulWidget {
  final Color color;
  final double size;

  const PulsingDot({
    super.key,
    this.color = const Color(0xff60a5fa),
    this.size = 6.0,
  });

  @override
  State<PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<PulsingDot> with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 0.6).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseOpacity = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Opacity(
          opacity: _pulseOpacity.value,
          child: Transform.scale(
            scale: _pulseScale.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.size / 2),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Header bar displaying protein meta-information and status.
class ProteinTopBar extends StatelessWidget {
  final String proteinName;
  final String confidenceText;

  const ProteinTopBar({
    super.key,
    required this.proteinName,
    this.confidenceText = "72% conf",
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.04,
        vertical: w * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Pill
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff12141d),
              border: Border.all(
                color: const Color(0xff2a2d3a),
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
                PulsingDot(color: const Color(0xff60a5fa), size: w * 0.015),
                SizedBox(width: w * 0.012),
                Text(
                  proteinName,
                  style: GoogleFonts.outfit(
                    fontSize: w * 0.026,
                    color: const Color(0xff64748b),
                  ),
                ),
              ],
            ),
          ),
          // Right Confidence Pill
          Container(
            decoration: BoxDecoration(
              color: const Color(0xff052e16),
              border: Border.all(
                color: const Color(0xff166534),
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
                Icon(
                  Icons.verified_user_outlined,
                  size: w * 0.03,
                  color: const Color(0xff4ade80),
                ),
                SizedBox(width: w * 0.01),
                Text(
                  confidenceText,
                  style: GoogleFonts.outfit(
                    fontSize: w * 0.026,
                    color: const Color(0xff4ade80),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Floating Hint prompting user interaction.
class ProteinTapHint extends StatelessWidget {
  const ProteinTapHint({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: w * 0.025),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xcc12141d),
            border: Border.all(
              color: const Color(0xff2a2d3a),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: w * 0.03,
            vertical: w * 0.01,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.touch_app_outlined,
                size: w * 0.032,
                color: const Color(0xff475569),
              ),
              SizedBox(width: w * 0.01),
              Text(
                "Tap a region to inspect",
                style: GoogleFonts.outfit(
                  fontSize: w * 0.025,
                  color: const Color(0xff475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Stat display card used in the details panel grid.
class ProteinStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? category;

  const ProteinStatCard({
    super.key,
    required this.label,
    required this.value,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.sizeOf(context).width;
    final Color valueColor = _getStatValueColor(value, category ?? label);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0d1020),
        border: Border.all(color: const Color(0xff1e2235), width: 0.5),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: w * 0.022,
              color: const Color(0xff475569),
              letterSpacing: 0.07,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: w * 0.005),
          Text(
            value,
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

  Color _getStatValueColor(String value, String categoryName) {
    final cat = categoryName.toLowerCase();
    final val = value.toLowerCase();

    if (cat == 'affinity' || cat == 'risk') {
      if (val == 'high' || val == 'critical') {
        return const Color(0xfff87171);
      }
      if (val == 'medium' || val == 'moderate') {
        return const Color(0xfffbbf24);
      }
      if (val == 'low' || val == 'stable' || val == 'safe') {
        return const Color(0xff4ade80);
      }
      return const Color(0xff94a3b8);
    }

    if (cat == 'plddt') {
      return const Color(0xfffbbf24);
    }

    return const Color(0xff94a3b8);
  }
}

/// Compact chip representing an individual region/domain.
class RegionChip extends StatelessWidget {
  final String regionKey;
  final RegionDetails details;
  final bool isSelected;
  final VoidCallback onTap;

  const RegionChip({
    super.key,
    required this.regionKey,
    required this.details,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff0c1a2e) : const Color(0xff1a1d27),
          border: Border.all(
            color: isSelected ? const Color(0xff2563eb) : const Color(0xff2a2d3a),
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
                borderRadius: BorderRadius.circular(w * 0.0075),
              ),
            ),
            SizedBox(width: w * 0.0125),
            Text(
              regionKey.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: w * 0.023,
                color: isSelected ? const Color(0xffbfdbfe) : const Color(0xff64748b),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sliding Overlay Drawer displaying rich domain statistics, affinity, danger bars, and descriptions.
class ProteinDetailPanel extends StatelessWidget {
  final Animation<double> animation;
  final double height;
  final String? selectedRegion;
  final RegionDetails? details;
  final Map<String, RegionDetails> regionMap;
  final VoidCallback onClose;
  final ValueChanged<String> onRegionSelected;

  const ProteinDetailPanel({
    super.key,
    required this.animation,
    required this.height,
    required this.selectedRegion,
    required this.details,
    required this.regionMap,
    required this.onClose,
    required this.onRegionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final activeDetails = details;
    if (activeDetails == null) {
      return const SizedBox.shrink();
    }
    final w = MediaQuery.sizeOf(context).width;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: animation.value * height,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xff12141d),
          border: Border(
            top: BorderSide(
              color: Color(0xff1e2235),
              width: 0.5,
            ),
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(w * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Panel Header Row
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
                          color: const Color(0xffe2e8f0),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      Icons.close,
                      color: const Color(0xff475569),
                      size: w * 0.045,
                    ),
                    onPressed: onClose,
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
                  ProteinStatCard(
                    label: "Chain",
                    value: activeDetails.chain,
                  ),
                  ProteinStatCard(
                    label: "Residues",
                    value: activeDetails.residues,
                  ),
                  ProteinStatCard(
                    label: "Atoms",
                    value: activeDetails.atoms,
                  ),
                  ProteinStatCard(
                    label: "pLDDT",
                    value: activeDetails.plddt.toString(),
                    category: 'pLDDT',
                  ),
                  ProteinStatCard(
                    label: "Affinity",
                    value: activeDetails.affinity,
                    category: 'Affinity',
                  ),
                  ProteinStatCard(
                    label: "Risk Level",
                    value: activeDetails.risk,
                    category: 'Risk',
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
                          color: const Color(0xff475569),
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
                          color: const Color(0xff1e2235),
                          borderRadius: BorderRadius.circular(99),
                        ),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          height: w * 0.0125,
                          width: activeDetails.dangerPercent * dangerConstraints.maxWidth,
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
                  color: const Color(0xff0d1020),
                  border: Border.all(
                    color: const Color(0xff1e2235),
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(9),
                ),
                padding: EdgeInsets.all(w * 0.02),
                child: Text(
                  activeDetails.description,
                  style: GoogleFonts.outfit(
                    fontSize: w * 0.028,
                    color: const Color(0xff64748b),
                    height: 1.5,
                  ),
                ),
              ),

              // Region Switcher Buttons inside details panel
              SizedBox(height: w * 0.025),
              Wrap(
                spacing: w * 0.015,
                runSpacing: w * 0.015,
                children: regionMap.entries.map((entry) {
                  final key = entry.key;
                  final details = entry.value;
                  return RegionChip(
                    regionKey: key,
                    details: details,
                    isSelected: selectedRegion == key,
                    onTap: () => onRegionSelected(key),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal Legend row mapping domains.
class ProteinLegendRow extends StatelessWidget {
  final Map<String, RegionDetails> regionMap;
  final String? selectedRegion;
  final ValueChanged<String> onRegionSelected;

  const ProteinLegendRow({
    super.key,
    required this.regionMap,
    required this.selectedRegion,
    required this.onRegionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xff1e2235), width: 0.5),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.025,
        vertical: w * 0.015,
      ),
      width: double.infinity,
      child: Wrap(
        spacing: w * 0.02,
        runSpacing: 4,
        children: regionMap.entries.map((entry) {
          final key = entry.key;
          final details = entry.value;
          final isSelected = selectedRegion == key;

          return GestureDetector(
            onTap: () => onRegionSelected(key),
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
                        ? const Color(0xffe2e8f0)
                        : const Color(0xff64748b),
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

/// Horizontal scrollable selector pills for 3D visualization representations.
class ProteinRepresentationModeSelector extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeSelected;

  const ProteinRepresentationModeSelector({
    super.key,
    required this.selectedMode,
    required this.onModeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xff1e2235), width: 0.5),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: w * 0.025,
        vertical: w * 0.015,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            'Ball+Stick',
            'Ribbon',
            'Surface',
            'Wireframe',
          ].map((mode) {
            final modeKey = mode == 'Ball+Stick' ? 'ball' : mode.toLowerCase();
            final isSelected = selectedMode.toLowerCase() == modeKey;
            return GestureDetector(
              onTap: () => onModeSelected(modeKey),
              child: Container(
                margin: EdgeInsets.only(right: w * 0.015),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xff1d4ed8) : const Color(0xff1a1d27),
                  border: Border.all(
                    color: isSelected ? const Color(0xff2563eb) : const Color(0xff2a2d3a),
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
                    color: isSelected ? const Color(0xffbfdbfe) : const Color(0xff475569),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

/// Individual control icon button helper.
class ProteinControlIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool highlighted;
  final bool highlightActive;

  const ProteinControlIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.highlighted = false,
    this.highlightActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = highlighted && highlightActive;
    final w = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w * 0.08,
        height: w * 0.08,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xff0c1a2e) : const Color(0xff1a1d27),
          border: Border.all(
            color: isActive ? const Color(0xff2563eb) : const Color(0xff2a2d3a),
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: w * 0.04,
          color: isActive ? const Color(0xff60a5fa) : const Color(0xff64748b),
        ),
      ),
    );
  }
}

/// Row of 3D view controllers (zoom, reset, active binding site highlight, fullscreen).
class ProteinControlButtonsRow extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetView;
  final VoidCallback onHighlightBindingSite;
  final VoidCallback onFullscreen;
  final bool highlightActive;

  const ProteinControlButtonsRow({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetView,
    required this.onHighlightBindingSite,
    required this.onFullscreen,
    this.highlightActive = true,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: EdgeInsets.only(
        left: w * 0.02,
        right: w * 0.02,
        bottom: w * 0.02,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ProteinControlIconButton(
            icon: Icons.zoom_in,
            onTap: onZoomIn,
          ),
          SizedBox(width: w * 0.015),
          ProteinControlIconButton(
            icon: Icons.zoom_out,
            onTap: onZoomOut,
          ),
          SizedBox(width: w * 0.015),
          ProteinControlIconButton(
            icon: Icons.refresh,
            onTap: onResetView,
          ),
          SizedBox(width: w * 0.015),
          ProteinControlIconButton(
            icon: Icons.center_focus_strong,
            onTap: onHighlightBindingSite,
            highlighted: true,
            highlightActive: highlightActive,
          ),
          SizedBox(width: w * 0.015),
          ProteinControlIconButton(
            icon: Icons.fullscreen,
            onTap: onFullscreen,
          ),
        ],
      ),
    );
  }
}
