class AlertModel {
  final String id;
  final String stakeholder;
  final String status;
  final String message;
  final String timestamp;
  final String type;
  final bool isRetraction;

  AlertModel({
    required this.id,
    required this.stakeholder,
    required this.status,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRetraction,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? '',
      stakeholder: json['stakeholder'] ?? '',
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      type: json['type'] ?? '',
      isRetraction: json['is_retraction'] ?? false,
    );
  }
}
