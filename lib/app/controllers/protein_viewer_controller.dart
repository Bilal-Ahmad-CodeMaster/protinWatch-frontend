import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import '../theme/app_theme.dart';

class ProteinViewerController extends GetxController {
  final String pdbData;
  late final WebViewController controller;
  final isLoading = true.obs;
  final hasError = false.obs;
  final isFullscreen = false.obs;
  final isFullscreenMounted = false.obs;

  ProteinViewerController({required this.pdbData});

  bool get isUnsupportedPlatform {
    try {
      return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
    } catch (_) {
      return kIsWeb;
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (isUnsupportedPlatform) {
      isLoading.value = false;
      hasError.value = true;
      return;
    }
    _initWebView();
  }

  void _initWebView() {
    if (isUnsupportedPlatform) return;
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppTheme.background)
      ..addJavaScriptChannel(
        'ProteinWatchChannel',
        onMessageReceived: (JavaScriptMessage message) {
          if (message.message == 'ready') {
            _injectPDB();
            isLoading.value = false;
          } else if (message.message.startsWith('error')) {
            hasError.value = true;
            isLoading.value = false;
          } else {
            try {
              final Map<String, dynamic> data = jsonDecode(message.message);
              if (data['type'] == 'atomClick') {
                final chainId = data['chainId'] ?? 'A';
                final residueName = data['residueName'] ?? '';
                final residueIndex = data['residueIndex'] ?? '';
                final atomName = data['atomName'] ?? '';
                
                Get.rawSnackbar(
                  title: 'Atom Selected',
                  message: 'Chain $chainId · $residueName $residueIndex · $atomName',
                  backgroundColor: const Color(0xff12141d),
                  messageText: Text(
                    'Chain $chainId · $residueName $residueIndex · $atomName',
                    style: const TextStyle(color: Color(0xff94a3b8), fontSize: 13),
                  ),
                  titleText: const Text(
                    'Atom Selected',
                    style: TextStyle(color: Color(0xffe2e8f0), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  duration: const Duration(seconds: 2),
                  margin: const EdgeInsets.all(15),
                  borderRadius: 10,
                  borderColor: const Color(0xff1e2235),
                  borderWidth: 0.5,
                );
              }
            } catch (_) {}
          }
        },
      );

    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    try {
      final String fileText = await rootBundle.loadString(
        'assets/ngl_viewer.html',
      );
      controller.loadHtmlString(fileText);
    } catch (e) {
      hasError.value = true;
      isLoading.value = false;
    }
  }

  void _injectPDB() {
    if (pdbData.isNotEmpty) {
      String decodedPdb = pdbData;
      if (!pdbData.contains(' ') && pdbData.length % 4 == 0) {
        try {
          decodedPdb = utf8.decode(base64.decode(pdbData.trim()));
        } catch (_) {}
      }
      final safePdb = decodedPdb
          .replaceAll('\n', '\\n')
          .replaceAll('\r', '')
          .replaceAll("'", "\\'");
      controller.runJavaScript("loadPDB('$safePdb')");
    }
  }

  void zoomIn() => controller.runJavaScript('zoomIn()');
  void zoomOut() => controller.runJavaScript('zoomOut()');
  void rotateModel() => controller.runJavaScript('rotateModel()');
  void resetView() => controller.runJavaScript('resetView()');
}
