import 'package:get/get.dart';
import '../services/api_service.dart';

class BriefController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final RxString briefText = ''.obs;
  final RxBool isStreaming = false.obs;
  final RxString language = 'en'.obs; // 'en' or 'ur'

  Future<void> fetchBriefStream(String sequenceId) async {
    isStreaming.value = true;
    briefText.value = '';
    
    try {
      await for (final chunk in _api.streamBrief(sequenceId, language.value)) {
        briefText.value += chunk;
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
