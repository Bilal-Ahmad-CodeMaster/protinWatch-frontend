import 'package:get/get.dart';
import '../services/api_service.dart';
import 'sequence_controller.dart';

class BriefController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final RxString briefText = ''.obs;
  final RxBool isStreaming = false.obs;
  final RxString language = 'en'.obs;

  Future<void> fetchBriefStream(String sequenceId) async {
    isStreaming.value = true;
    briefText.value = '';

    final sequenceController = Get.find<SequenceController>();
    final sequence =
        sequenceController.sequences.firstWhereOrNull(
          (s) => s.id == sequenceId,
        ) ??
        sequenceController.selectedSequence.value;

    try {
      if (sequence != null) {
        await for (final chunk in _api.streamBrief(
          sequence: sequence.sequenceString,
          threatIndex: sequence.threatScore.combinedThreatIndex.toDouble(),
          kmer: sequence.threatScore.kmerScore.toDouble(),
          esm: sequence.threatScore.esm2Score.toDouble(),
          language: language.value,
        )) {
          briefText.value += chunk;
        }
      } else {
        await for (final chunk in _api.streamBrief(
          sequence: sequenceId,
          threatIndex: 0.0,
          kmer: 0.0,
          esm: 0.0,
          language: language.value,
        )) {
          briefText.value += chunk;
        }
      }
    } finally {
      isStreaming.value = false;
    }
  }

  void toggleLanguage(String sequenceId) {
    language.value = language.value == 'en' ? 'ur' : 'en';
    fetchBriefStream(sequenceId);
  }
}
