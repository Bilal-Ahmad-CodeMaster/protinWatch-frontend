import 'dart:async';
import 'package:get/get.dart';
import 'sequence_controller.dart';
import 'threat_controller.dart';
import 'brief_controller.dart';

class ReplayController extends GetxController {
  final SequenceController _sequenceController = Get.find<SequenceController>();
  final ThreatController _threatController = Get.find<ThreatController>();
  final BriefController _briefController = Get.find<BriefController>();

  final RxBool replayActive = false.obs;
  final RxInt replayStep = 0.obs;

  // Screen-specific timeline playback state
  final RxDouble progress = 0.0.obs;
  final RxBool isPlaying = false.obs;
  final RxString geminiText = ''.obs;
  final RxInt geminiCharIndex = 0.obs;

  Timer? _screenTimer;

  final String fullGeminiText =
      "URGENT PUBLIC HEALTH ALERT: Analysis of novel coronavirus sequence from Wuhan, China indicates highly unusual binding affinity to human ACE2 receptors. The structural prediction strongly suggests high transmissibility. Immediate containment measures are recommended.";

  final DateTime startDate = DateTime(2019, 12, 1);
  final DateTime endDate = DateTime(2020, 2, 1);

  @override
  void onClose() {
    _screenTimer?.cancel();
    super.onClose();
  }

  void togglePlay() {
    if (isPlaying.value) {
      _screenTimer?.cancel();
      isPlaying.value = false;
    } else {
      if (progress.value >= 1.0) reset();
      isPlaying.value = true;
      _screenTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        progress.value += 0.005;
        if (progress.value >= 1.0) {
          progress.value = 1.0;
          isPlaying.value = false;
          timer.cancel();
        }

        if (progress.value >= 0.75) {
          int charCount =
              (((progress.value - 0.75) / 0.25) * fullGeminiText.length)
                  .toInt();
          if (charCount > fullGeminiText.length) {
            charCount = fullGeminiText.length;
          }
          geminiText.value = fullGeminiText.substring(0, charCount);
          geminiCharIndex.value = charCount;
        }
      });
    }
  }

  void skip() {
    _screenTimer?.cancel();
    progress.value = 1.0;
    isPlaying.value = false;
    geminiText.value = fullGeminiText;
    geminiCharIndex.value = fullGeminiText.length;
  }

  void reset() {
    _screenTimer?.cancel();
    progress.value = 0.0;
    isPlaying.value = false;
    geminiText.value = '';
    geminiCharIndex.value = 0;
  }

  void updateProgress(double value) {
    progress.value = value;
    if (value < 0.75) {
      geminiText.value = '';
      geminiCharIndex.value = 0;
    } else {
      int charCount = ((value - 0.75) / 0.25 * fullGeminiText.length).toInt();
      if (charCount > fullGeminiText.length) {
        charCount = fullGeminiText.length;
      }
      geminiText.value = fullGeminiText.substring(0, charCount);
      geminiCharIndex.value = charCount;
    }
  }

  String currentDateLabel() {
    final diff = endDate.difference(startDate).inMilliseconds;
    final currentMs =
        startDate.millisecondsSinceEpoch + (diff * progress.value).round();
    final current = DateTime.fromMillisecondsSinceEpoch(currentMs);
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[current.month - 1]} ${current.day} ${current.year}";
  }

  Future<void> startCovidReplay() async {
    if (replayActive.value) return;

    replayActive.value = true;
    replayStep.value = 0;

    // We assume the offline COVID-19 sequence is selected or we select it
    if (_sequenceController.sequences.isNotEmpty) {
      _sequenceController.selectedSequence.value =
          _sequenceController.sequences.first;
    }

    final seq = _sequenceController.selectedSequence.value;
    if (seq == null) {
      replayActive.value = false;
      return;
    }

    _sequenceController.currentLayer.value = 1; // Layer 1: NCBI ingestion
    _threatController.updateStagedScores(0, 0, 0.0, 0); // reset

    // Stage 1: 1.5s -> Layer 2 K-mer
    await Future.delayed(const Duration(milliseconds: 1500));
    _sequenceController.currentLayer.value = 2;
    _threatController.updateStagedScores(seq.threatScore.kmerScore, 0, 0.0, 0);

    // Stage 2: 3s -> Layer 3 ESM-2
    await Future.delayed(const Duration(milliseconds: 1500));
    _sequenceController.currentLayer.value = 3;
    _threatController.updateStagedScores(
      seq.threatScore.kmerScore,
      seq.threatScore.esm2Score,
      0.0,
      0,
    );

    // Stage 3: 5s -> Layer 4 AlphaFold
    await Future.delayed(const Duration(milliseconds: 2000));
    _sequenceController.currentLayer.value = 4;
    _threatController.updateStagedScores(
      seq.threatScore.kmerScore,
      seq.threatScore.esm2Score,
      seq.threatScore.structuralTmScore,
      seq.threatScore.combinedThreatIndex,
    );

    // Stage 4: 7s -> Layer 5 Gemini Stream
    await Future.delayed(const Duration(milliseconds: 2000));
    _sequenceController.currentLayer.value = 5;
    await _briefController.fetchBriefStream(seq.id);

    // Stage 5: 9s -> Layer 6 Action dispatch
    await Future.delayed(const Duration(milliseconds: 2000));
    _sequenceController.currentLayer.value = 6;
    _threatController.alertFired.value = true;

    replayActive.value = false;
  }
}
