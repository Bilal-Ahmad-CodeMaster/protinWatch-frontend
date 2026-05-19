import '../repositories/i_crisis_repository.dart';
import '../../models/crisis_model.dart';
import '../providers/mock_data_loader.dart';

class MockCrisisRepository implements ICrisisRepository {
  @override
  Future<List<CrisisModel>> fetchCrises() async {
    final data = await MockDataLoader.loadJson('assets/mock/crises.json');
    return (data as List).map((e) => CrisisModel.fromJson(e)).toList();
  }
}
