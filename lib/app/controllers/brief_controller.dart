import 'package:get/get.dart';
import '../services/api_service.dart';
import 'sequence_controller.dart';

class SeparatorMatch {
  final int index;
  final int length;
  SeparatorMatch(this.index, this.length);
}

class BriefController extends GetxController {
  final ApiService _api = Get.find<ApiService>();

  final RxString briefText = ''.obs;
  final RxBool isStreaming = false.obs;
  final RxString language = 'en'.obs;

  SeparatorMatch? _findUrduSeparator(String text) {
    final lower = text.toLowerCase();
    
    // Find the first occurrence of "urdu" case-insensitively
    final urduIdx = lower.indexOf('urdu');
    if (urduIdx == -1) return null;
    
    // Look backward up to 10 characters for prefix formatting like '**', '##', or '---'
    int startIndex = urduIdx;
    for (int i = urduIdx - 1; i >= 0 && i >= urduIdx - 10; i--) {
      if (text.substring(i).startsWith('**') ||
          text.substring(i).startsWith('##') ||
          text.substring(i).startsWith('---')) {
        startIndex = i;
        break;
      }
    }
    
    // Look forward up to 35 characters for closing formatting like '**', ':', or a newline '\n'
    int endIndex = urduIdx + 4;
    for (int i = urduIdx + 4; i < text.length && i <= urduIdx + 35; i++) {
      if (text.substring(i).startsWith('**')) {
        endIndex = i + 2;
        break;
      } else if (text.substring(i).startsWith('\n')) {
        endIndex = i + 1;
        break;
      }
    }
    
    return SeparatorMatch(startIndex, endIndex - startIndex);
  }

  String _cleanEnglishPrefix(String text) {
    var cleaned = text.trim();
    final lower = cleaned.toLowerCase();
    
    final prefixes = [
      '**english crisis brief**',
      '**english version**',
      '**english brief**',
      '**english translation**',
      '**english**',
      'english crisis brief:',
      'english version:',
      'english brief:',
    ];
    
    for (final prefix in prefixes) {
      if (lower.startsWith(prefix)) {
        cleaned = cleaned.substring(prefix.length).trim();
        break;
      }
    }
    
    // Also check if it starts with "**english" followed by closing "**"
    if (cleaned.toLowerCase().startsWith('**english')) {
      final closingIdx = cleaned.indexOf('**', 9);
      if (closingIdx != -1) {
        cleaned = cleaned.substring(closingIdx + 2).trim();
      }
    }
    
    return cleaned;
  }

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
      String accumulated = '';
      
      final stream = sequence != null
          ? _api.streamBrief(
              sequence: sequence.sequenceString,
              threatIndex: sequence.threatScore.combinedThreatIndex.toDouble(),
              kmer: sequence.threatScore.kmerScore.toDouble(),
              esm: sequence.threatScore.esm2Score.toDouble(),
              language: language.value,
            )
          : _api.streamBrief(
              sequence: sequenceId,
              threatIndex: 0.0,
              kmer: 0.0,
              esm: 0.0,
              language: language.value,
            );

      await for (final chunk in stream) {
        accumulated += chunk;

        final match = _findUrduSeparator(accumulated);
        if (match != null) {
          if (language.value == 'ur') {
            // Urdu: show everything after the separator
            briefText.value = accumulated.substring(match.index + match.length).trim();
          } else {
            // English: show everything before the separator
            final rawEn = accumulated.substring(0, match.index).trim();
            briefText.value = _cleanEnglishPrefix(rawEn);
          }
        } else {
          if (language.value == 'en') {
            // If separator hasn't arrived yet and we want English, show the current accumulated text
            briefText.value = _cleanEnglishPrefix(accumulated.trim());
          } else {
            // If we want Urdu but separator hasn't arrived yet, keep the UI waiting/clean
            briefText.value = 'Preparing translation...';
          }
        }
      }
    } catch (e) {
      print('BriefController streaming error: $e');
      briefText.value = language.value == 'ur'
          ? 'تفصیلات حاصل کرنے میں دشواری پیش آئی۔'
          : 'Failed to compile brief.';
    } finally {
      isStreaming.value = false;
    }
  }

  void toggleLanguage(String sequenceId) {
    language.value = language.value == 'en' ? 'ur' : 'en';
    fetchBriefStream(sequenceId);
  }
}
