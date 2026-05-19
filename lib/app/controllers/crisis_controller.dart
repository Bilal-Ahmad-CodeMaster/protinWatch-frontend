import 'package:get/get.dart';
import '../data/repositories/i_crisis_repository.dart';
import '../models/crisis_model.dart';

class CrisisController extends GetxController {
  final ICrisisRepository repository;
  CrisisController({required this.repository});

  final crises = <CrisisModel>[].obs;
  final isLoading = true.obs;
  final activeCrisisId = 'ISL-FLOOD-001'.obs;

  @override
  void onInit() {
    super.onInit();
    loadCrises();
  }

  Future<void> loadCrises() async {
    isLoading.value = true;
    try {
      crises.value = await repository.fetchCrises();
    } finally {
      isLoading.value = false;
    }
  }

  void updateSeverity(String id, int newSeverity) {
    int index = crises.indexWhere((c) => c.id == id);
    if (index != -1) {
      final old = crises[index];
      crises[index] = CrisisModel(
        id: old.id,
        type: old.type,
        location: old.location,
        lat: old.lat,
        lng: old.lng,
        severity: newSeverity,
        confidence: old.confidence,
        affectedPopulation: old.affectedPopulation,
        durationEstimate: old.durationEstimate,
        status: old.status,
      );
    }
  }

  CrisisModel? get activeCrisis {
    try {
      return crises.firstWhere((c) => c.id == activeCrisisId.value);
    } catch (e) {
      return null;
    }
  }
}
