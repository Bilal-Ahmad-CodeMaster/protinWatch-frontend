import '../../models/signal_model.dart';

abstract class ISignalRepository {
  Future<List<SignalModel>> fetchSignals();
}
