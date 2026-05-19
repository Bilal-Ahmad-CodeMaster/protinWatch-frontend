class AgentTraceModel {
  final String agentName;
  final String status;
  final String timestamp;
  final String log;
  final int executionTimeMs;

  AgentTraceModel({
    required this.agentName,
    required this.status,
    required this.timestamp,
    required this.log,
    required this.executionTimeMs,
  });

  factory AgentTraceModel.fromJson(Map<String, dynamic> json) {
    return AgentTraceModel(
      agentName: json['agent_name'] ?? '',
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
      log: json['log'] ?? '',
      executionTimeMs: json['execution_time_ms'] ?? 0,
    );
  }
}
