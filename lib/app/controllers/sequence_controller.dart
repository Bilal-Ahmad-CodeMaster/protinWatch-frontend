import 'package:get/get.dart';
import '../models/sequence_model.dart';
import '../services/api_service.dart';

class SequenceController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final RxList<SequenceModel> sequences = <SequenceModel>[].obs;
  final Rx<SequenceModel?> selectedSequence = Rx<SequenceModel?>(null);
  
  final RxBool isAnalyzing = false.obs;
  final RxInt currentLayer = 0.obs;

  // Live health and database metrics from the backend
  final RxString serverStatus = 'Connecting...'.obs;
  final RxInt dbCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
    fetchHealthStatus();
  }

  Future<void> fetchHealthStatus() async {
    try {
      final health = await _api.checkHealth();
      if (health['status'] == 'ok') {
        serverStatus.value = 'OK';
        dbCount.value = health['db_count'] ?? 0;
      } else {
        serverStatus.value = 'Offline';
      }
    } catch (_) {
      serverStatus.value = 'Offline';
    }
  }

  Future<void> _loadHistory() async {
    try {
      final history = await _api.getHistory();
      sequences.value = history;
      if (history.isNotEmpty) {
        selectedSequence.value = history.first;
      }
    } catch (e) {
      print('SequenceController error loading history: $e');
    }
  }

  Future<void> analyze(String sequence) async {
    isAnalyzing.value = true;
    currentLayer.value = 1; // Start at layer 1
    
    try {
      final result = await _api.analyzeSequence(sequence);
      selectedSequence.value = result;
      // Refresh health stats after analysis is done
      await fetchHealthStatus();
    } finally {
      isAnalyzing.value = false;
    }
  }
}
