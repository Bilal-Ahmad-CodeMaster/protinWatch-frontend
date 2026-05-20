import 'dart:async';
import 'package:get/get.dart';
import 'sequence_controller.dart';
import 'threat_controller.dart';
import 'brief_controller.dart';

class ReplayController extends GetxController {
  // Use lazy getters to prevent 'BriefController not found' crash when instantiated eager
  SequenceController get _sequenceController => Get.find<SequenceController>();
  ThreatController get _threatController => Get.find<ThreatController>();
  BriefController get _briefController => Get.find<BriefController>();

  final RxBool replayActive = false.obs;
  final RxInt replayStep = 0.obs;

  // Screen-specific timeline playback state
  final RxDouble progress = 0.0.obs;
  final RxBool isPlaying = false.obs;
  final RxString geminiText = ''.obs;
  final RxInt geminiCharIndex = 0.obs;
  
  // Playback speed: 0.5, 1.0, or 2.0
  final RxDouble playbackSpeed = 1.0.obs;

  Timer? _screenTimer;

  final String fullGeminiText =
      "URGENT PUBLIC HEALTH ALERT: Analysis of novel coronavirus sequence from Wuhan, China indicates highly unusual binding affinity to human ACE2 receptors. The structural prediction strongly suggests high transmissibility. Immediate containment measures are recommended.";

  // timeline Dec 26, 2019 to Jan 30, 2020
  final DateTime startDate = DateTime(2019, 12, 26);
  final DateTime endDate = DateTime(2020, 1, 30);

  @override
  void onClose() {
    _screenTimer?.cancel();
    super.onClose();
  }

  void setSpeed(double speed) {
    playbackSpeed.value = speed;
    if (isPlaying.value) {
      // Restart timer with new speed
      togglePlay();
      togglePlay();
    }
  }

  void togglePlay() {
    if (isPlaying.value) {
      _screenTimer?.cancel();
      isPlaying.value = false;
    } else {
      if (progress.value >= 1.0) reset();
      isPlaying.value = true;
      
      // Timer ticks every 100ms.
      // Total timeline has 100 ticks at 1x speed (10s total).
      // So at 1x speed, we add 0.01 progress per tick.
      _screenTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        progress.value += 0.01 * playbackSpeed.value;
        if (progress.value >= 1.0) {
          progress.value = 1.0;
          isPlaying.value = false;
          timer.cancel();
        }
        _updateProgressState(progress.value);
      });
    }
  }

  void skip() {
    _screenTimer?.cancel();
    progress.value = 1.0;
    isPlaying.value = false;
    _updateProgressState(1.0);
  }

  void reset() {
    _screenTimer?.cancel();
    progress.value = 0.0;
    isPlaying.value = false;
    _updateProgressState(0.0);
  }

  void updateProgress(double value) {
    progress.value = value;
    _updateProgressState(value);
  }

  void _updateProgressState(double value) {
    // Stage 3 (AI Brief) is between progress 0.50 and 0.70
    if (value < 0.50) {
      geminiText.value = '';
      geminiCharIndex.value = 0;
    } else if (value >= 0.50 && value < 0.70) {
      double stage3Fraction = ((value - 0.50) / 0.20).clamp(0.0, 1.0);
      int charCount = (stage3Fraction * fullGeminiText.length).toInt();
      geminiText.value = fullGeminiText.substring(0, charCount);
      geminiCharIndex.value = charCount;
    } else {
      geminiText.value = fullGeminiText;
      geminiCharIndex.value = fullGeminiText.length;
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
    return "${months[current.month - 1]} ${current.day}, ${current.year}";
  }

  Future<void> startCovidReplay() async {
    if (!isPlaying.value) {
      reset();
      togglePlay();
    }
  }
}
