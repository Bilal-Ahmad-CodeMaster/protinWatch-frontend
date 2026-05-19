class CrisisModel {
  final String id;
  final String type;
  final String location;
  final double lat;
  final double lng;
  final int severity;
  final int confidence;
  final int affectedPopulation;
  final String durationEstimate;
  final String status;

  CrisisModel({
    required this.id,
    required this.type,
    required this.location,
    required this.lat,
    required this.lng,
    required this.severity,
    required this.confidence,
    required this.affectedPopulation,
    required this.durationEstimate,
    required this.status,
  });

  factory CrisisModel.fromJson(Map<String, dynamic> json) {
    return CrisisModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      lat: (json['coordinates']?['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['coordinates']?['lng'] as num?)?.toDouble() ?? 0.0,
      severity: json['severity'] ?? 0,
      confidence: json['confidence'] ?? 0,
      affectedPopulation: json['affected_population'] ?? 0,
      durationEstimate: json['duration_estimate'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
