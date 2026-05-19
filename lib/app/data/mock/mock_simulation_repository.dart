import '../repositories/i_simulation_repository.dart';
import '../../models/simulation_model.dart';
import '../providers/mock_data_loader.dart';

class MockSimulationRepository implements ISimulationRepository {
  @override
  Future<SimulationModel> fetchSimulation() async {
    final data = await MockDataLoader.loadJson('assets/mock/simulation.json');
    return SimulationModel.fromJson(data);
  }
}
