import '../repositories/i_signal_repository.dart';
import '../../models/signal_model.dart';
import '../providers/mock_data_loader.dart';

class MockSignalRepository implements ISignalRepository {
  @override
  Future<List<SignalModel>> fetchSignals() async {
    final data = await MockDataLoader.loadJson('assets/mock/signals.json');
    return (data as List).map((e) => SignalModel.fromJson(e)).toList();
  }
}
