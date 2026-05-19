class SequenceModel {
  final String id;
  final String name;
  final String sequenceString;
  final String originLocation;
  final double latitude;
  final double longitude;
  final DateTime detectionDate;
  final ThreatScoreModel threatScore;
  final AlertModel? alert;
  final List<AgentStepModel> agentTrace;
  final String closestMatch;
  final String geminiBriefEn;
  final String geminiBriefUr;
  final String pdbStructure;

  SequenceModel({
    required this.id,
    required this.name,
    required this.sequenceString,
    required this.originLocation,
    required this.latitude,
    required this.longitude,
    required this.detectionDate,
    required this.threatScore,
    this.alert,
    required this.agentTrace,
    required this.closestMatch,
    required this.geminiBriefEn,
    required this.geminiBriefUr,
    required this.pdbStructure,
  });

  factory SequenceModel.fromJson(Map<String, dynamic> json) {
    final double lat = json['latitude'] != null
        ? (json['latitude'] as num).toDouble()
        : (json['lat'] != null
              ? double.tryParse(json['lat'].toString()) ?? 0.0
              : 0.0);
    final double lng = json['longitude'] != null
        ? (json['longitude'] as num).toDouble()
        : (json['lng'] != null
              ? double.tryParse(json['lng'].toString()) ?? 0.0
              : 0.0);

    final String? rawLoc = json['origin_location'] ?? json['location'];
    final String resolvedLocation =
        (rawLoc != null &&
            rawLoc.trim().isNotEmpty &&
            rawLoc.trim().toLowerCase() != 'unknown')
        ? rawLoc
        : () {
            // Coordinate-to-location professional mappings
            if ((lat - 29.3957).abs() < 0.01 && (lng - 71.6833).abs() < 0.01) {
              return 'Punjab • Bahawalpur, Pakistan';
            }
            if ((lat - 33.7).abs() < 0.1 && (lng - 112.6).abs() < 0.1) {
              return 'East Asia • Wuhan, China';
            }
            if ((lat - 9.0).abs() < 0.1 && (lng - (-1.5)).abs() < 0.1) {
              return 'West Africa • Lagos, Nigeria';
            }
            if ((lat - 52.5).abs() < 0.1 && (lng - 13.4).abs() < 0.1) {
              return 'Europe • Berlin, Germany';
            }
            if ((lat - 40.7).abs() < 0.1 && (lng - (-74.0)).abs() < 0.1) {
              return 'North America • New York, USA';
            }

            // Regional heuristics fallbacks based on coordinates
            if (lat > 23.0 && lat < 37.0 && lng > 60.0 && lng < 80.0) {
              return 'South Asia • Pakistan';
            }
            if (lat > 20.0 && lat < 45.0 && lng > 100.0 && lng < 125.0) {
              return 'East Asia • China';
            }
            if (lat > 35.0 && lat < 70.0 && lng > -10.0 && lng < 40.0) {
              return 'Europe';
            }
            if (lat > 25.0 && lat < 49.0 && lng > -125.0 && lng < -65.0) {
              return 'North America • USA';
            }
            if (lat > -35.0 && lat < 37.0 && lng > -20.0 && lng < 51.0) {
              return 'Africa';
            }
            return 'Global Watchlist';
          }();

    return SequenceModel(
      id: json['id'] ?? json['analysis_id'] ?? 'PW-000',
      name: json['name'] ?? json['closest_match'] ?? 'Unknown Sequence',
      sequenceString: json['sequence'] ?? '',
      originLocation: resolvedLocation,
      latitude: lat,
      longitude: lng,
      detectionDate: () {
        try {
          if (json['detection_date'] != null) {
            return DateTime.parse(json['detection_date']);
          }
          final alertTimestamp = json['alert']?['timestamp']?.toString();
          if (alertTimestamp != null) {
            final cleaned = alertTimestamp.replaceAll(' UTC', '');
            return DateTime.parse(cleaned);
          }
        } catch (_) {}
        return DateTime.now();
      }(),
      threatScore: ThreatScoreModel(
        kmerScore: ((json['kmer_score'] ?? json['kmer'] ?? 0) as num).toInt(),
        esm2Score: ((json['esm2_score'] ?? json['esm'] ?? 0) as num).toInt(),
        structuralTmScore: (() {
          double score = ((json['structural_score'] ?? json['structural_tm_score'] ?? 0.0) as num).toDouble();
          return score > 1.0 ? score / 100.0 : score;
        })(),
        combinedThreatIndex:
            ((json['threat_index'] ?? json['combined_threat_index'] ?? 0)
                    as num)
                .toInt(),
      ),
      alert: json['alert_ticket'] != null
          ? AlertModel.fromJson(json['alert_ticket'])
          : (json['alert'] != null ? AlertModel.fromJson(json['alert']) : null),
      agentTrace:
          ((json['agent_trace'] ?? json['alert']?['agent_trace'])
                  as List<dynamic>?)
              ?.map((e) => AgentStepModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      closestMatch: json['closest_match'] ?? 'None',
      geminiBriefEn: json['gemini_brief_en'] ?? '',
      geminiBriefUr: json['gemini_brief_ur'] ?? '',
      pdbStructure:
          json['pdb_structure'] ?? json['pdb'] ?? json['pdb_id'] ?? '',
    );
  }
}

class ThreatScoreModel {
  final int kmerScore;
  final int esm2Score;
  final double structuralTmScore;
  final int combinedThreatIndex;

  ThreatScoreModel({
    required this.kmerScore,
    required this.esm2Score,
    required this.structuralTmScore,
    required this.combinedThreatIndex,
  });
}

class AlertModel {
  final String alertId;
  final String timestamp;
  final String beforeState;
  final String afterState;
  final List<String> actionsTaken;

  AlertModel({
    required this.alertId,
    required this.timestamp,
    required this.beforeState,
    required this.afterState,
    required this.actionsTaken,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      alertId: json['alert_id'] ?? '',
      timestamp: json['timestamp'] ?? '',
      beforeState: json['before_state'] ?? '',
      afterState: json['after_state'] ?? '',
      actionsTaken: List<String>.from(json['actions_taken'] ?? []),
    );
  }
}

class AgentStepModel {
  final String agent;
  final String action;
  final String timestamp;
  final String color;

  AgentStepModel({
    required this.agent,
    required this.action,
    required this.timestamp,
    required this.color,
  });

  factory AgentStepModel.fromJson(Map<String, dynamic> json) {
    return AgentStepModel(
      agent: json['agent'] ?? '',
      action: json['action'] ?? '',
      timestamp: json['timestamp'] ?? '',
      color: json['color'] ?? 'blue',
    );
  }
}
