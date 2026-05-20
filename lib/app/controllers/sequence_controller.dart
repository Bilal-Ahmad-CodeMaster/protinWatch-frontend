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
    print('DEBUG: SequenceController._loadHistory() called');
    try {
      final history = await _api.getHistory();
      
      // Deduplicate by virus name keeping only highest score entry
      final Map<String, SequenceModel> uniqueSequences = {};
      for (var sequence in history) {
        final existing = uniqueSequences[sequence.name];
        if (existing == null || 
            sequence.threatScore.combinedThreatIndex > existing.threatScore.combinedThreatIndex) {
          uniqueSequences[sequence.name] = sequence;
        }
      }
      final deduplicatedList = uniqueSequences.values.toList();

      sequences.value = deduplicatedList;
      if (deduplicatedList.isNotEmpty) {
        selectedSequence.value = deduplicatedList.first;
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
      print('--- DEBUG: Trace list length after /analyze: ${result.agentTrace.length} ---');
      selectedSequence.value = result;
      // Refresh health stats after analysis is done
      await fetchHealthStatus();
    } finally {
      isAnalyzing.value = false;
    }
  }
}
