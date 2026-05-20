import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/theme/app_theme.dart';
import 'app/views/screens/splash_screen.dart';
import 'app/services/api_service.dart';
import 'app/controllers/sequence_controller.dart';
import 'app/controllers/threat_controller.dart';
import 'app/controllers/brief_controller.dart';
import 'app/controllers/map_controller.dart';
import 'app/controllers/replay_controller.dart';
import 'app/controllers/resource_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final apiService = ApiService();
  await apiService.init();
  Get.put(apiService);

  runApp(const ProteinWatchApp());
}

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Inject Controllers
    Get.lazyPut(() => SequenceController());
    Get.lazyPut(() => ThreatController());
    Get.lazyPut(() => BriefController());
    Get.lazyPut(() => MapController());
    Get.lazyPut(() => ReplayController());
    Get.lazyPut(() => ResourceController());
  }
}

class ProteinWatchApp extends StatelessWidget {
  const ProteinWatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Protein Watch - BioSurveillance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: InitialBindings(),
      home: const SplashScreen(),
    );
  }
}
