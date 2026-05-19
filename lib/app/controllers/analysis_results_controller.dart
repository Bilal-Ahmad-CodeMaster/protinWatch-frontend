import 'package:get/get.dart';

class AnalysisResultsController extends GetxController {
  final String sequence;

  AnalysisResultsController({required this.sequence});

  final RxBool isLoading = true.obs;
  final RxInt activeStep = 0.obs;
  final RxBool showResults = false.obs;
  final RxMap<int, String> stepResults = <int, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    startAnalysis();
  }

  Future<void> startAnalysis() async {
    for (int i = 0; i < 6; i++) {
      await Future.delayed(const Duration(milliseconds: 500));
      activeStep.value = i + 1;
      if (i == 1) stepResults[1] = '73 Novelty Score';
      if (i == 2) stepResults[2] = '91 Danger Score';
      if (i == 3) stepResults[3] = 'TM-Score 0.84';
      if (i == 4) stepResults[4] = 'Brief Generated';
      if (i == 5) stepResults[5] = 'Alert PW-2019-001 Dispatched';
    }

    isLoading.value = false;
    showResults.value = true;
  }
}
