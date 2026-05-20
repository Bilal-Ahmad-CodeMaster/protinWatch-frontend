import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/replay_controller.dart';
import '../../controllers/sequence_controller.dart';
import '../../controllers/threat_controller.dart';
import '../../controllers/brief_controller.dart';
import '../../theme/app_theme.dart';
import '../widgets/action_panel/action_panel.dart';
import '../widgets/highlighted_brief_text.dart';
import '../../models/sequence_model.dart';

class ReplayScreen extends GetView<ReplayController> {
  const ReplayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    // Resilient registration to prevent dependency crashes
    if (!Get.isRegistered<SequenceController>()) Get.put(SequenceController());
    if (!Get.isRegistered<ThreatController>()) Get.put(ThreatController());
    if (!Get.isRegistered<BriefController>()) Get.put(BriefController());
    final c = Get.put(ReplayController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dark Blue Premium Header Card
            Container(
              clipBehavior: Clip.hardEdge,
              width: double.infinity,
              padding: EdgeInsets.all(w * 0.05),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F1E36), Color(0xFF070B19)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppTheme.infoBlue.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'COVID-19 Replay',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: w * 0.05,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'December 26, 2019 — 35 days before WHO alert',
                              style: GoogleFonts.outfit(
                                color: AppTheme.infoBlue,
                                fontSize: w * 0.028,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.cardBorder),
                            ),
                            child: Text(
                              c.currentDateLabel(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.outfit(
                                color: AppTheme.primaryText,
                                fontSize: w * 0.032,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: w * 0.04),

                  // Custom Timeline progress track
                  Obx(() {
                    final progress = c.progress.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Timeline Bar
                        Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            // Gray Track background
                            Container(
                              height: 6,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppTheme.cardBorder,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                            // Filled Progress
                            FractionallySizedBox(
                              widthFactor: progress,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppTheme.infoBlue,
                                      Color(0xFF00FF88),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.infoBlue.withValues(
                                        alpha: 0.5,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Red beacon marker at Jan 30 (representing the far right end)
                            Positioned(
                              right: 0,
                              top: -4,
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppTheme.criticalRed,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.criticalRed.withValues(
                                        alpha: 0.8,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Current active glowing beacon
                            if (progress > 0 && progress < 1.0)
                              Positioned(
                                left:
                                    (MediaQuery.sizeOf(context).width -
                                        w * 0.18) *
                                    progress,
                                top: -3,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00FF88),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Dec 26, 2019',
                              style: GoogleFonts.outfit(
                                color: AppTheme.secondaryText,
                                fontSize: w * 0.026,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppTheme.criticalRed,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      'Jan 30 WHO Alert',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        color: AppTheme.criticalRed,
                                        fontSize: w * 0.026,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            SizedBox(height: w * 0.04),

            // Playback controls panel
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: w * 0.02,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Playback control buttons
                  Row(
                    children: [
                      Obx(
                        () => ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: c.isPlaying.value
                                ? AppTheme.warningAmber.withValues(alpha: 0.2)
                                : AppTheme.infoBlue.withValues(alpha: 0.2),
                            foregroundColor: c.isPlaying.value
                                ? AppTheme.warningAmber
                                : AppTheme.infoBlue,
                            side: BorderSide(
                              color: c.isPlaying.value
                                  ? AppTheme.warningAmber
                                  : AppTheme.infoBlue,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: Icon(
                            c.isPlaying.value ? Icons.pause : Icons.play_arrow,
                            size: 18,
                          ),
                          label: Text(
                            c.isPlaying.value ? 'Pause' : 'Play',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: c.togglePlay,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        tooltip: 'Skip to End',
                        icon: const Icon(
                          Icons.fast_forward,
                          color: AppTheme.secondaryText,
                        ),
                        onPressed: c.skip,
                      ),
                      IconButton(
                        tooltip: 'Reset',
                        icon: const Icon(
                          Icons.refresh,
                          color: AppTheme.secondaryText,
                        ),
                        onPressed: c.reset,
                      ),
                    ],
                  ),

                  // Speed Selector Capsules
                  Row(
                    children: [
                      Text(
                        'Speed: ',
                        style: GoogleFonts.outfit(
                          color: AppTheme.secondaryText,
                          fontSize: w * 0.028,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Row(
                        children: [0.5, 1.0, 2.0].map((speed) {
                          return Obx(() {
                            final isSelected = c.playbackSpeed.value == speed;
                            return GestureDetector(
                              onTap: () => c.setSpeed(speed),
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.infoBlue.withValues(
                                          alpha: 0.15,
                                        )
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppTheme.infoBlue
                                        : AppTheme.cardBorder,
                                    width: 1.2,
                                  ),
                                ),
                                child: Text(
                                  '${speed}x',
                                  style: GoogleFonts.outfit(
                                    color: isSelected
                                        ? AppTheme.infoBlue
                                        : AppTheme.secondaryText,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: w * 0.028,
                                  ),
                                ),
                              ),
                            );
                          });
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: w * 0.05),

            // Staged Timeline Reveal List
            Obx(() {
              final progress = c.progress.value;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stage 1: Threat Score Card (progress >= 0.15)
                  if (progress >= 0.15)
                    _buildStageCard(
                          title: 'Stage 1: Genomic Threat Evaluation',
                          dateText: 'December 26, 2019',
                          w: w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Combined Threat Index',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.secondaryText,
                                      fontSize: w * 0.03,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.criticalRed.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: AppTheme.criticalRed.withValues(
                                          alpha: 0.3,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      'CRITICAL',
                                      style: GoogleFonts.outfit(
                                        color: AppTheme.criticalRed,
                                        fontWeight: FontWeight.bold,
                                        fontSize: w * 0.024,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '85',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.criticalRed,
                                      fontSize: w * 0.08,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '/100',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.mutedText,
                                      fontSize: w * 0.04,
                                    ),
                                  ),
                                  const Spacer(),
                                  _buildMetricPill(
                                    label: 'K-mer Novelty',
                                    score: '73%',
                                    color: AppTheme.warningAmber,
                                    w: w,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildMetricPill(
                                    label: 'ESM-2 Density',
                                    score: '91%',
                                    color: AppTheme.criticalRed,
                                    w: w,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 500))
                        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),

                  // Stage 2: 3D Structure Matching Card (progress >= 0.30)
                  if (progress >= 0.30)
                    _buildStageCard(
                          title: 'Stage 2: 3D Structural Validation',
                          dateText: 'December 26, 2019',
                          w: w,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.purpleStructural.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.view_in_ar_rounded,
                                  color: AppTheme.purpleStructural,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'AlphaFold structure confirmed spike protein match',
                                      style: GoogleFonts.outfit(
                                        color: AppTheme.primaryText,
                                        fontSize: w * 0.032,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Structural simulation of receptor binding domain (RBD) verifies high binding affinity pathway to human ACE2 receptors.',
                                      style: GoogleFonts.outfit(
                                        color: AppTheme.secondaryText,
                                        fontSize: w * 0.026,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 500))
                        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),

                  // Stage 3: AI Brief Card (progress >= 0.50)
                  if (progress >= 0.50)
                    _buildStageCard(
                          title: 'Stage 3: Crisis Intelligence Briefing',
                          dateText: 'December 26, 2019',
                          w: w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.auto_awesome,
                                    color: AppTheme.infoBlue,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Gemini Autonomous Public Health Briefing',
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.primaryText,
                                      fontSize: w * 0.028,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Obx(
                                () => HighlightedBriefText(
                                  text: c.geminiText.value,
                                  w: w,
                                  isUrdu: false,
                                ),
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 500))
                        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),

                  // Stage 4: Agent Trace List (progress >= 0.70)
                  if (progress >= 0.70)
                    _buildStageCard(
                          title: 'Stage 4: Autonomous Biosurveillance Trace',
                          dateText: 'December 26, 2019',
                          w: w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTraceItem(
                                stepNumber: 1,
                                agentName: 'GenomicIngestionAgent',
                                actionDesc:
                                    'Wuhan novel coronavirus spike protein sequence ingested from NCBI GenBank.',
                                isVisible: progress >= 0.70,
                                w: w,
                              ),
                              _buildTraceItem(
                                stepNumber: 2,
                                agentName: 'GenomicAnalysisAgent',
                                actionDesc:
                                    'K-mer analysis (73%) and ESM-2 scoring (91%) triggered. Combined Threat Index evaluated at 85.',
                                isVisible: progress >= 0.74,
                                w: w,
                              ),
                              _buildTraceItem(
                                stepNumber: 3,
                                agentName: 'StructuralValidationAgent',
                                actionDesc:
                                    'AlphaFold structural model matching confirmed. High human ACE2 receptor affinity verified.',
                                isVisible: progress >= 0.78,
                                w: w,
                              ),
                              _buildTraceItem(
                                stepNumber: 4,
                                agentName: 'CrisisBriefingAgent',
                                actionDesc:
                                    'Gemini crisis report generated in English and Urdu. Forwarded notification protocol to response systems.',
                                isVisible: progress >= 0.82,
                                w: w,
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 500))
                        .slideY(begin: 0.15, end: 0, curve: Curves.easeOutQuad),

                  // Stage 5: Action Protocol (progress >= 0.88)
                  if (progress >= 0.88)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              'Stage 5: Global Response Dispatch Protocol Activated',
                              style: GoogleFonts.outfit(
                                color: AppTheme.secondaryText,
                                fontSize: w * 0.03,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ActionPanelWidget(
                                isActive: true,
                                alertId: 'PW-2019-001',
                                threatIndex: 85,
                                kmerScore: 73,
                                esm2Score: 91,
                                structuralScore: 84,
                                virusName: 'Novel Coronavirus (COVID-19)',
                                sequenceName: 'Wuhan spike protein RBD',
                                uniprotId: 'EPI_ISL_402124',
                                agentTrace: [
                                  AgentStepModel(
                                    agent: 'GenomicIngestionAgent',
                                    action:
                                        'Wuhan novel coronavirus sequence ingested from NCBI GenBank.',
                                    timestamp: 'Dec 26, 2019 · 11:30 UTC',
                                    color: 'blue',
                                  ),
                                  AgentStepModel(
                                    agent: 'GenomicAnalysisAgent',
                                    action:
                                        'K-mer (73%) and ESM-2 (91%) scores trigger Combined Threat of 85.',
                                    timestamp: 'Dec 26, 2019 · 11:31 UTC',
                                    color: 'yellow',
                                  ),
                                  AgentStepModel(
                                    agent: 'StructuralValidationAgent',
                                    action:
                                        'AlphaFold structure confirms high-affinity human ACE2 matching.',
                                    timestamp: 'Dec 26, 2019 · 11:32 UTC',
                                    color: 'purple',
                                  ),
                                  AgentStepModel(
                                    agent: 'CrisisBriefingAgent',
                                    action:
                                        'Gemini briefing finalized and response protocol triggered.',
                                    timestamp: 'Dec 26, 2019 · 11:33 UTC',
                                    color: 'green',
                                  ),
                                ],
                              )
                              .animate()
                              .fadeIn(
                                duration: const Duration(milliseconds: 600),
                              )
                              .slideY(
                                begin: 0.1,
                                end: 0,
                                curve: Curves.easeOutQuad,
                              ),
                        ],
                      ),
                    ),

                  // Final Reveal: 35 DAYS EARLIER (progress >= 1.0)
                  if (progress >= 1.0)
                    Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10, bottom: 40),
                          padding: EdgeInsets.all(w * 0.06),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF4A0E17,
                            ), // Dark red premium color
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.criticalRed,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.criticalRed.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 30,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: AppTheme.safeGreen,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '35 DAYS EARLIER',
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: w * 0.065,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Than the official WHO declaration — January 30, 2020',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.primaryText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: w * 0.034,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'ProteinWatch detected this on December 26, 2019',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.safeGreen,
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.038,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                        .animate()
                        .fadeIn(duration: const Duration(milliseconds: 600))
                        .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                        ),
                ],
              );
            }),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildStageCard({
    required String title,
    required String dateText,
    required double w,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(w * 0.04),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                dateText,
                style: GoogleFonts.outfit(
                  color: AppTheme.mutedText,
                  fontSize: w * 0.026,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(color: AppTheme.cardBorder, height: 1),
          ),
          child,
        ],
      ),
    );
  }

  Widget _buildMetricPill({
    required String label,
    required String score,
    required Color color,
    required double w,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.outfit(
              color: AppTheme.secondaryText,
              fontSize: w * 0.026,
            ),
          ),
          Text(
            score,
            style: GoogleFonts.outfit(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: w * 0.028,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraceItem({
    required int stepNumber,
    required String agentName,
    required String actionDesc,
    required bool isVisible,
    required double w,
  }) {
    if (!isVisible) return const SizedBox.shrink();

    return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.infoBlue, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        '$stepNumber',
                        style: GoogleFonts.outfit(
                          color: AppTheme.infoBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(width: 2, color: AppTheme.cardBorder),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        agentName,
                        style: GoogleFonts.outfit(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.bold,
                          fontSize: w * 0.03,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        actionDesc,
                        style: GoogleFonts.outfit(
                          color: AppTheme.secondaryText,
                          fontSize: w * 0.026,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 300))
        .slideX(begin: -0.1, end: 0, curve: Curves.easeOutQuad);
  }
}
