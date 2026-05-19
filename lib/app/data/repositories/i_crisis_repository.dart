import '../../models/crisis_model.dart';

abstract class ICrisisRepository {
  Future<List<CrisisModel>> fetchCrises();
}
