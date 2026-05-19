import 'package:get/get.dart';
import '../models/sequence_model.dart';
import '../services/api_service.dart';

class SequenceController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final RxList<SequenceModel> sequences = <SequenceModel>[].obs;
  final Rx<SequenceModel?> selectedSequence = Rx<SequenceModel?>(null);
  
  final RxBool isAnalyzing = false.obs;
  final RxInt currentLayer = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _api.getHistory();
    sequences.value = history;
    if (history.isNotEmpty) {
      selectedSequence.value = history.first;
    }
  }

  Future<void> analyze(String sequence) async {
    isAnalyzing.value = true;
    currentLayer.value = 1; // Start at layer 1
    
    // The replay controller handles the mock delays for the showcase, 
    // but if we were actually calling the API live without replay:
    try {
      final result = await _api.analyzeSequence(sequence);
      selectedSequence.value = result;
    } finally {
      isAnalyzing.value = false;
    }
  }
}
