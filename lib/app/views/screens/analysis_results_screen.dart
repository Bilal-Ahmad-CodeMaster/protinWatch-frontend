import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../controllers/analysis_results_controller.dart';
import '../widgets/pipeline_stepper.dart';
import '../widgets/threat/threat_score_card.dart';
import '../widgets/action_panel/action_panel.dart';
import '../widgets/alert_brief_card.dart';

class AnalysisResultsScreen extends StatelessWidget {
  final String sequence;

  const AnalysisResultsScreen({super.key, required this.sequence});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    final c = Get.put(
      AnalysisResultsController(sequence: sequence),
      tag: sequence,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          'Pipeline Analysis',
          style: GoogleFonts.outfit(
            color: AppTheme.primaryText,
            fontSize: w * 0.05,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.background,
        iconTheme: IconThemeData(color: AppTheme.primaryText, size: w * 0.055),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: w * 0.04,
          right: w * 0.04,
          top: w * 0.02,
          bottom: w * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Obx(
              () => Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.03,
                  vertical: w * 0.02,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.cardSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: c.isLoading.value
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.infoBlue,
                            )
                          : const Icon(
                              Icons.check_circle,
                              color: AppTheme.safeGreen,
                            ),
                    ),
                    SizedBox(width: w * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.isLoading.value
                                ? 'Analyzing Sequence...'
                                : 'Analysis Complete',
                            style: GoogleFonts.outfit(
                              color: AppTheme.primaryText,
                              fontWeight: FontWeight.bold,
                              fontSize: w * 0.04,
                            ),
                          ),
                          SizedBox(height: w * 0.01),
                          Text(
                            sequence.length > 50
                                ? '${sequence.substring(0, 50)}...'
                                : sequence,
                            style: GoogleFonts.outfit(
                              color: AppTheme.mutedText,
                              fontSize: w * 0.03,
                            ),

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: w * 0.02),

            // Stepper
            Obx(
              () => PipelineStepperWidget(
                activeStep: c.activeStep.value,
                stepResults: c.stepResults,
              ),
            ),

            Obx(() {
              if (!c.showResults.value) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: w * 0.01),
                  const ThreatScoreCard(
                    threatIndex: 91,
                    kmerScore: 0.73,
                    esm2Score: 0.91,
                    structuralScore: 0.84,
                  ).animate().fade().scale(),
                  SizedBox(height: w * 0.03),
                  const ActionPanelWidget(
                    isActive: true,
                    alertId: 'PW-2019-001',
                  ).animate().fade().slideY(begin: 0.1),
                  SizedBox(height: w * 0.03),
                  const AlertBriefCard(
                    whoText:
                        'ProteinWatch AI indicates a novel coronavirus spike protein with 84% structural homology to SARS-CoV but with enhanced binding affinity to ACE2. Immediate attention is recommended.',
                    cdcText:
                        'US CDC EOC: Novel respiratory virus sequence detected in Wuhan. Elevated K-mer novelty score (73) and high ESM-2 danger score (91). Protocol Alpha-1 recommended.',
                    hospitalText:
                        'HOSPITAL ALERT: Prepare for potential severe respiratory outbreak. Ensure adequate stockpile of PPE and ventilators.',
                    mediaText:
                        'A new viral threat has been identified by ProteinWatch early-warning systems, tracking a novel virus in Wuhan, China. Health authorities have been notified.',
                    urduText:
                        'پروٹین واچ اے آئی نے ووہان میں ایک نئے وائرس کی نشاندہی کی ہے۔ یہ وائرس سارس جیسا ہے لیکن زیادہ تیزی سے پھیل سکتا ہے۔ فوری اقدامات کی ضرورت ہے۔',
                  ).animate().fade().slideY(begin: 0.2),
                  SizedBox(height: w * 0.04),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
