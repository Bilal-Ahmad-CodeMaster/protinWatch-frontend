import 'package:get/get.dart';
import '../data/repositories/i_signal_repository.dart';
import '../models/signal_model.dart';

class SignalController extends GetxController {
  final ISignalRepository repository;
  SignalController({required this.repository});

  final allSignals = <SignalModel>[].obs;
  final visibleSignals = <SignalModel>[].obs;
  final isLoading = true.obs;
  final selectedFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSignals();
  }

  Future<void> loadSignals() async {
    isLoading.value = true;
    try {
      allSignals.value = await repository.fetchSignals();
      applyFilter('All');
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilter(String type) {
    selectedFilter.value = type;
    if (type == 'All') {
      visibleSignals.value = allSignals;
    } else {
      visibleSignals.value = allSignals
          .where((s) => s.type.toLowerCase() == type.toLowerCase())
          .toList();
    }
  }

  void resolveConflictSignal() {
    int index = allSignals.indexWhere((s) => s.type == 'conflict');
    if (index != -1) {
      final old = allSignals[index];
      allSignals[index] = SignalModel(
        id: old.id,
        crisisId: old.crisisId,
        source: 'AI Verification Node',
        credibility: 'retracted',
        content: 'RETRACTED: Previous report of dam collapse is FALSE. Verification complete.',
        confidence: 100,
        timeAgo: 'Just now',
        type: 'conflict',
      );
      applyFilter(selectedFilter.value);
    }
  }
}
