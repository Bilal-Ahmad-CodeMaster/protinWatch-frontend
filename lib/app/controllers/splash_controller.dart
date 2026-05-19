import 'package:get/get.dart';
import '../views/screens/command_center_shell.dart';

class SplashController extends GetxController {
  final loadingProgress = 0.0.obs;
  final statusText = 'Initializing Threat Intelligence Pipeline...'.obs;

  @override
  void onInit() {
    super.onInit();
    _runBootSequence();
  }

  Future<void> _runBootSequence() async {
    await Future.delayed(const Duration(milliseconds: 600));
    loadingProgress.value = 0.35;
    statusText.value = 'Loading Cellular Databases...';

    await Future.delayed(const Duration(milliseconds: 700));
    loadingProgress.value = 0.70;
    statusText.value = 'Connecting to Global Networks...';

    await Future.delayed(const Duration(milliseconds: 600));
    loadingProgress.value = 1.0;
    statusText.value = 'Secure Pipeline Deployed';

    await Future.delayed(const Duration(milliseconds: 600));
    Get.off(
      () => const CommandCenterShell(),
      transition: Transition.fadeIn,
      duration: const Duration(milliseconds: 800),
    );
  }
}
