import '../../models/simulation_model.dart';

abstract class ISimulationRepository {
  Future<SimulationModel> fetchSimulation();
}
