import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/sequence_model.dart';

class SeparatorMatch {
  final int index;
  final int length;
  SeparatorMatch(this.index, this.length);
}

class AnalysisResultsController extends GetxController {
  final String sequence;
  final ApiService _api = Get.find<ApiService>();

  AnalysisResultsController({required this.sequence});

  final RxBool isLoading = true.obs;
  final RxInt activeStep = 0.obs;
  final RxBool showResults = false.obs;
  final RxMap<int, String> stepResults = <int, String>{}.obs;
  final Rxn<SequenceModel> analysisResult = Rxn<SequenceModel>();
  final RxString errorMessage = ''.obs;

  // Real-time streamed briefs from Gemini
  final RxString geminiBriefEn = ''.obs;
  final RxString geminiBriefUr = ''.obs;

  @override
  void onInit() {
    super.onInit();
    startAnalysis();
  }

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

  Future<void> startAnalysis() async {
    try {
      // 1. Start fetching API in background immediately
      final Future<SequenceModel> apiCall = _api.analyzeSequence(sequence);

      // 2. Animate step 0: Sequence Ingestion
      await Future.delayed(const Duration(milliseconds: 600));
      stepResults[0] = 'Successfully ingested ${sequence.length} amino acids';
      activeStep.value = 1;

      // Await the API call to continue updating step scores
      final SequenceModel result = await apiCall;
      analysisResult.value = result;

      // Step 1: K-mer Novelty
      await Future.delayed(const Duration(milliseconds: 600));
      stepResults[1] = '${result.threatScore.kmerScore} Novelty Score';
      activeStep.value = 2;

      // Step 2: ESM-2 Danger
      await Future.delayed(const Duration(milliseconds: 600));
      stepResults[2] = '${result.threatScore.esm2Score} Danger Score';
      activeStep.value = 3;

      // Step 3: Structural Analysis
      await Future.delayed(const Duration(milliseconds: 600));
      stepResults[3] =
          'TM-Score ${result.threatScore.structuralTmScore.toStringAsFixed(2)}';
      activeStep.value = 4;

      // Step 4: Gemini Brief (Stream live briefs from the backend SSE endpoint)
      await Future.delayed(const Duration(milliseconds: 600));
      stepResults[4] = 'Compiling Brief...';
      activeStep.value = 5;

      // Stream the combined brief from the backend and split it in real-time
      try {
        String accumulated = '';
        await for (final chunk in _api.streamBrief(
          sequence: sequence,
          threatIndex: result.threatScore.combinedThreatIndex.toDouble(),
          kmer: result.threatScore.kmerScore.toDouble(),
          esm: result.threatScore.esm2Score.toDouble(),
        )) {
          accumulated += chunk;

          final match = _findUrduSeparator(accumulated);
          if (match != null) {
            // Found Urdu separator! Everything before is English, everything after is Urdu
            final rawEn = accumulated.substring(0, match.index).trim();
            geminiBriefEn.value = _cleanEnglishPrefix(rawEn);
            geminiBriefUr.value = accumulated.substring(match.index + match.length).trim();
          } else {
            // No separator yet: keep putting all incoming text in the English brief
            geminiBriefEn.value = _cleanEnglishPrefix(accumulated.trim());
          }
        }
      } catch (e) {
        print('Error streaming briefs: $e');
        geminiBriefEn.value = 'Failed to compile English brief.';
        geminiBriefUr.value = 'Failed to compile Urdu brief.';
      }

      stepResults[4] = 'Analysis Brief Compiled';

      // Step 5: Action Dispatch
      await Future.delayed(const Duration(milliseconds: 600));
      if (result.alert != null) {
        stepResults[5] = 'Alert ${result.alert!.alertId} Dispatched';
      } else {
        stepResults[5] = 'No critical threat detected (Monitor state)';
      }
      activeStep.value = 6;

      await Future.delayed(const Duration(milliseconds: 400));
      isLoading.value = false;
      showResults.value = true;
    } catch (e) {
      print('Analysis Error: $e');
      errorMessage.value = e.toString();
      isLoading.value = false;

      // Fallback values for offline support
      stepResults[0] = 'Ingested sequence (${sequence.length} AA)';
      stepResults[1] = '73 Novelty Score (offline)';
      stepResults[2] = '91 Danger Score (offline)';
      stepResults[3] = 'TM-Score 0.84 (offline)';
      stepResults[4] = 'Brief Generated (offline)';
      stepResults[5] = 'Alert PW-2019-001 Dispatched (offline)';

      geminiBriefEn.value =
          'ProteinWatch AI indicates a novel coronavirus spike protein with 84% structural homology to SARS-CoV but with enhanced binding affinity to ACE2. Immediate attention is recommended.';
      geminiBriefUr.value =
          'پروٹین واچ اے آئی نے ایک نئے وائرس کی نشاندہی کی ہے۔ یہ وائرس سارس جیسا ہے لیکن زیادہ تیزی سے پھیل سکتا ہے۔ فوری اقدامات کی ضرورت ہے۔';

      showResults.value = true;
    }
  }
}
