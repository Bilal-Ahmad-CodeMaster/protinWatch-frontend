import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/replay_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/action_panel/action_panel.dart';

class ReplayScreen extends GetView<ReplayController> {
  const ReplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    final c = Get.put(ReplayController());

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Replay',
              style: GoogleFonts.outfit(
                color: AppTheme.secondaryText,
                fontSize: w * 0.05,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: w * 0.03),

            // Player controls
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: w * 0.01,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(w * 0.05),
                border: .all(color: AppTheme.cardBorder),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          c.currentDateLabel(),
                          style: GoogleFonts.outfit(
                            color: AppTheme.primaryText,
                            fontSize: w * 0.05,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Obx(
                            () => IconButton(
                              icon: Icon(
                                c.isPlaying.value
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: AppTheme.infoBlue,
                              ),
                              onPressed: c.togglePlay,
                              iconSize: w * 0.07,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fast_forward,
                              color: AppTheme.secondaryText,
                            ),
                            onPressed: c.skip,
                            iconSize: w * 0.07,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              color: AppTheme.secondaryText,
                            ),
                            onPressed: c.reset,
                            iconSize: w * 0.07,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Obx(
                    () => Slider(
                      value: c.progress.value,
                      onChanged: c.updateProgress,
                      activeColor: AppTheme.infoBlue,
                      inactiveColor: AppTheme.cardBorder,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: w * 0.03),

            // State Reveals
            Obx(() {
              final progress = c.progress.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (progress >= 0.35)
                    _buildScoreWidget(
                          'K-mer Novelty Score',
                          73,
                          w: w,
                          AppTheme.warningAmber,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  if (progress >= 0.50)
                    _buildScoreWidget(
                          'ESM-2 Danger Score',
                          91,
                          AppTheme.criticalRed,
                          w: w,
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  if (progress >= 0.65)
                    _buildScoreWidget(
                          'Structural TM-Score',
                          84,
                          w: w,
                          AppTheme.criticalRed,
                          subtitle: '0.84',
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  if (progress >= 0.75)
                    Container(
                          margin: EdgeInsets.only(bottom: w * 0.02),
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.02,
                            vertical: w * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.cardSurface,
                            borderRadius: BorderRadius.circular(w * 0.04),
                            border: Border.all(
                              color: AppTheme.purpleStructural.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: w * 0.01),
                              Row(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: AppTheme.purpleStructural,
                                    size: w * 0.05,
                                  ),
                                  SizedBox(width: w * 0.02),
                                  Text(
                                    'Gemini Intelligence Brief',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.primaryText,
                                      fontWeight: FontWeight.w600,
                                      fontSize: w * 0.038,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: w * 0.01),
                              Obx(
                                () => Text(
                                  c.geminiText.value,
                                  style: GoogleFonts.outfit(
                                    color: AppTheme.primaryText,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  if (progress >= 0.85)
                    const ActionPanelWidget(
                          isActive: true,
                          alertId: 'PW-2019-001',
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

                  if (progress >= 0.85) ...[
                    SizedBox(height: w * 0.04),
                    Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.03,
                            vertical: w * 0.02,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.safeGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(w * 0.04),
                            border: Border.all(
                              color: AppTheme.safeGreen.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'ProteinWatch Dec 26 2019 vs WHO Jan 30 2020 = 35 days earlier.',
                            style: GoogleFonts.outfit(
                              color: AppTheme.safeGreen,
                              fontWeight: FontWeight.w600,
                              fontSize: w * 0.036,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                  ],
                ],
              );
            }),
            SizedBox(height: w * 0.25),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreWidget(
    String title,
    int score,
    Color color, {
    String? subtitle,
    required double w,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: w * 0.02),
      padding: EdgeInsets.all(w * 0.03),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(w * 0.04),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: AppTheme.primaryText,
              fontSize: w * 0.038,
              fontWeight: .w600,
            ),
          ),
          Row(
            children: [
              Text(
                subtitle ?? '$score',
                style: GoogleFonts.outfit(
                  color: color,
                  fontSize: w * 0.05,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle == null)
                Text(
                  '/100',
                  style: GoogleFonts.outfit(
                    color: color.withValues(alpha: 0.5),
                    fontSize: w * 0.035,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
