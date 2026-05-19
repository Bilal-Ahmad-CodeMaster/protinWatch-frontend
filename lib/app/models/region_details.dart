import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Region Details Data Model representing structural domains of a protein.
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

/// Predefined region selection models mapping.
const Map<String, RegionDetails> regionDetailsMap = {
  'rbd': RegionDetails(
    name: 'Receptor Binding Domain (RBD)',
    chain: 'A',
    residues: '319–541',
    atoms: '1847',
    plddt: 68.4,
    affinity: 'High',
    risk: 'Critical',
    color: AppTheme.criticalRed,
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
    color: AppTheme.infoBlue,
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
    color: AppTheme.warningAmber,
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
    color: AppTheme.purpleStructural,
    dangerPercent: 0.22,
    description:
        'Membrane anchor region. Conserved across known strains. No anomalous structural features detected.',
  ),
};
