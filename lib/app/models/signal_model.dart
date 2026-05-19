class SignalModel {
  final String id;
  final String crisisId;
  final String source;
  final String credibility;
  final String content;
  final int confidence;
  final String timeAgo;
  final String type;

  SignalModel({
    required this.id,
    required this.crisisId,
    required this.source,
    required this.credibility,
    required this.content,
    required this.confidence,
    required this.timeAgo,
    required this.type,
  });

  factory SignalModel.fromJson(Map<String, dynamic> json) {
    return SignalModel(
      id: json['id'] ?? '',
      crisisId: json['crisis_id'] ?? '',
      source: json['source'] ?? '',
      credibility: json['credibility'] ?? '',
      content: json['content'] ?? '',
      confidence: json['confidence'] ?? 0,
      timeAgo: json['time_ago'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
