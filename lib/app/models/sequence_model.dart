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
    return SequenceModel(
      id: json['id'] ?? 'PW-000',
      name: json['name'] ?? 'Unknown Sequence',
      sequenceString: json['sequence'] ?? '',
      originLocation: json['origin_location'] ?? 'Unknown',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      detectionDate: json['detection_date'] != null 
          ? DateTime.parse(json['detection_date']) 
          : DateTime.now(),
      threatScore: ThreatScoreModel(
        kmerScore: (json['kmer_score'] ?? 0).toInt(),
        esm2Score: (json['esm2_score'] ?? 0).toInt(),
        structuralTmScore: (json['structural_tm_score'] ?? 0.0).toDouble(),
        combinedThreatIndex: (json['combined_threat_index'] ?? 0).toInt(),
      ),
      alert: json['alert_ticket'] != null ? AlertModel.fromJson(json['alert_ticket']) : null,
      agentTrace: (json['agent_trace'] as List<dynamic>?)
              ?.map((e) => AgentStepModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      closestMatch: json['closest_match'] ?? 'None',
      geminiBriefEn: json['gemini_brief_en'] ?? '',
      geminiBriefUr: json['gemini_brief_ur'] ?? '',
      pdbStructure: json['pdb_structure'] ?? '',
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
