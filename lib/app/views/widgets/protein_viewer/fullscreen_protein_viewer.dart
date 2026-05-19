import 'package:crio_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/protein_viewer_controller.dart';

/// A professional fullscreen 3D protein viewer overlay.
class FullscreenProteinViewer extends StatelessWidget {
  final ProteinViewerController controller;
  final String proteinName;
  final VoidCallback onClose;

  const FullscreenProteinViewer({
    super.key,
    required this.controller,
    required this.proteinName,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        onClose();
      },
      child: Scaffold(
        backgroundColor: AppTheme.cardSurface,
        appBar: AppBar(
          backgroundColor: AppTheme.cardSurface,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Color(0xff64748b)),
            onPressed: onClose,
          ),
          title: Text(
            "$proteinName (3D Model)",
            style: GoogleFonts.outfit(
              color: AppTheme.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            if (controller.isFullscreenMounted.value) {
              return WebViewWidget(controller: controller.controller);
            } else {
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.infoBlue),
              );
            }
          }),
        ),
      ),
    );
  }
}
