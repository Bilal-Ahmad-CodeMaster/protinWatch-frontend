class SimulationState {
  final String responseTime;
  final String congestionLevel;
  final int teamsDeployed;
  final String hospitalStatus;
  final String roadRerouting;

  SimulationState({
    required this.responseTime,
    required this.congestionLevel,
    required this.teamsDeployed,
    required this.hospitalStatus,
    required this.roadRerouting,
  });

  factory SimulationState.fromJson(Map<String, dynamic> json) {
    return SimulationState(
      responseTime: json['response_time'] ?? '',
      congestionLevel: json['congestion_level'] ?? '',
      teamsDeployed: json['teams_deployed'] ?? 0,
      hospitalStatus: json['hospital_status'] ?? '',
      roadRerouting: json['road_rerouting'] ?? '',
    );
  }
}

class SimulationModel {
  final String crisisId;
  final SimulationState beforeState;
  final SimulationState afterState;
  final String sideEffectsWarning;

  SimulationModel({
    required this.crisisId,
    required this.beforeState,
    required this.afterState,
    required this.sideEffectsWarning,
  });

  factory SimulationModel.fromJson(Map<String, dynamic> json) {
    return SimulationModel(
      crisisId: json['crisis_id'] ?? '',
      beforeState: SimulationState.fromJson(json['before_state'] ?? {}),
      afterState: SimulationState.fromJson(json['after_state'] ?? {}),
      sideEffectsWarning: json['side_effects_warning'] ?? '',
    );
  }
}
