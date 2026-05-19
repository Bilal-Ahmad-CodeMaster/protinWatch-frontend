import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Register controller so it boots the sequence immediately
    Get.put(SplashController());

    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Background watermark / subtle glow layer
          Positioned.fill(
            child: Opacity(
              opacity: 0.04,
              child: Image.asset('assets/images/logo.png', fit: BoxFit.cover),
            ),
          ),

          // Centre branding block
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                      'assets/images/logo.png',
                      width: w * 0.42,
                      height: w * 0.42,
                    )
                    .animate()
                    .fade(duration: 800.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      duration: 800.ms,
                      curve: Curves.easeOutBack,
                    )
                    .then()
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .shimmer(
                      delay: 1000.ms,
                      duration: 1800.ms,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),

                SizedBox(height: h * 0.04),

                // App title
                Text(
                      'Protein Watch',
                      style: GoogleFonts.outfit(
                        color: AppTheme.primaryText,
                        fontSize: w * 0.065,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.0,
                      ),
                    )
                    .animate()
                    .fade(delay: 300.ms, duration: 600.ms)
                    .slideY(begin: 0.2, delay: 300.ms, duration: 600.ms),

                SizedBox(height: h * 0.01),

                // Subtitle
                Text(
                      'Advanced Bio-Surveillance Platform',
                      style: GoogleFonts.outfit(
                        color: AppTheme.infoBlue,
                        fontSize: w * 0.026,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    )
                    .animate()
                    .fade(delay: 500.ms, duration: 600.ms)
                    .slideY(begin: 0.2, delay: 500.ms, duration: 600.ms),
              ],
            ),
          ),

          // Bottom loading bar + reactive status text
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: h * 0.08),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Reactive status text via Obx
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      child: Text(
                        controller.statusText.value,
                        key: ValueKey<String>(controller.statusText.value),
                        style: GoogleFonts.outfit(
                          color: AppTheme.secondaryText.withValues(alpha: 0.65),
                          fontSize: w * 0.024,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: h * 0.015),

                  // Reactive animated loading bar via Obx
                  Container(
                    width: w * 0.6,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppTheme.cardBorder,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Stack(
                      children: [
                        Obx(
                          () => AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            width: w * 0.6 * controller.loadingProgress.value,
                            height: 4,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppTheme.infoBlue,
                                  AppTheme.criticalRed,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.infoBlue.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
