import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../models/sequence_model.dart';
import '../services/api_service.dart';

class SequenceController extends GetxController with WidgetsBindingObserver {
  final ApiService _api = Get.find<ApiService>();

  final RxList<SequenceModel> sequences = <SequenceModel>[].obs;
  final Rx<SequenceModel?> selectedSequence = Rx<SequenceModel?>(null);

  final RxBool isAnalyzing = false.obs;
  final RxInt currentLayer = 0.obs;

  final RxString serverStatus = 'Connecting...'.obs;
  final RxInt dbCount = 0.obs;

  static const int totalCycleSeconds = 1800;
  final RxInt secondsRemaining = totalCycleSeconds.obs;
  Timer? _countdownTimer;

  String get formattedTimeRemaining {
    final minutes = secondsRemaining.value ~/ 60;
    final seconds = secondsRemaining.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> refreshData() async {
    print(
      'DEBUG: SequenceController.refreshData() called - Resetting timer to 30m',
    );
    await _loadHistory(resetTimer: true);
    await fetchHealthStatus();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    secondsRemaining.value = totalCycleSeconds;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining.value > 0) {
        secondsRemaining.value--;

        if (secondsRemaining.value % 3 == 0) {
          dbCount.value += 1;
        }
      } else {
        _countdownTimer?.cancel();
        _loadHistory(resetTimer: true);
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _loadHistory();
    fetchHealthStatus();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _countdownTimer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshData();
    }
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

  Future<void> _loadHistory({bool resetTimer = true}) async {
    print(
      'DEBUG: SequenceController._loadHistory(resetTimer: $resetTimer) called',
    );
    try {
      final history = await _api.getHistory();

      sequences.value = history;
      if (history.isNotEmpty) {
        selectedSequence.value = history.first;
      }
    } catch (e) {
      print('SequenceController error loading history: $e');
    } finally {
      if (resetTimer) {
        _startCountdown();
      }
    }
  }

  Future<void> analyze(String sequence) async {
    isAnalyzing.value = true;
    currentLayer.value = 1; // Start at layer 1

    try {
      final result = await _api.analyzeSequence(sequence);
      print(
        '--- DEBUG: Trace list length after /analyze: ${result.agentTrace.length} ---',
      );
      selectedSequence.value = result;
      // Refresh health stats after analysis is done
      await fetchHealthStatus();
    } finally {
      isAnalyzing.value = false;
    }
  }
}
