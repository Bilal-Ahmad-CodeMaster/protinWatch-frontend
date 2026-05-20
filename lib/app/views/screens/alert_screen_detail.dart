import 'package:crio_app/app/models/sequence_model.dart';
import 'package:crio_app/app/theme/app_theme.dart';
import 'package:crio_app/app/views/widgets/action_panel/action_panel.dart';
import 'package:crio_app/app/views/widgets/threat/threat_score_card.dart';
import 'package:crio_app/app/views/widgets/protein_viewer/protein_viewer.dart';
import 'package:crio_app/app/services/api_service.dart';
import 'package:crio_app/app/controllers/brief_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../widgets/highlighted_brief_text.dart';

class AlertDetailsPage extends StatelessWidget {
  final SequenceModel alert;

  const AlertDetailsPage({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    // Filter out action-related steps that belong only in ActionPanelWidget
    final filteredAgentTrace = alert.agentTrace.where((step) {
      final a = step.agent.toLowerCase();
      final act = step.action.toLowerCase();
      return !a.contains('who notif') && !a.contains('travel advis') && !a.contains('labs shared') &&
             !act.contains('who notif') && !act.contains('travel advis') && !act.contains('labs shared');
    }).toList();
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          alert.name,
          style: GoogleFonts.outfit(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.w600,
            fontSize: w * 0.05,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.background,
        iconTheme: IconThemeData(color: AppTheme.primaryText, size: w * 0.055),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThreatScoreCard(
              threatIndex: alert.threatScore.combinedThreatIndex.toDouble(),
              kmerScore: alert.threatScore.kmerScore / 100,
              esm2Score: alert.threatScore.esm2Score / 100,
              structuralScore: alert.threatScore.structuralTmScore,
            ).animate().fade().scale(),
            SizedBox(height: w * 0.015),

            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: w * 0.02,
              ),
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(w * 0.02),
                    decoration: BoxDecoration(
                      color: AppTheme.infoBlue.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppTheme.infoBlue,
                      size: w * 0.055,
                    ),
                  ),
                  SizedBox(width: w * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Origin',
                          style: GoogleFonts.outfit(
                            color: AppTheme.secondaryText,
                            fontSize: w * 0.028,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: w * 0.01),
                        Text(
                          alert.originLocation,
                          style: GoogleFonts.outfit(
                            color: AppTheme.primaryText,
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.025,
                      vertical: w * 0.01,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Text(
                      '${alert.latitude.toStringAsFixed(1)}°, ${alert.longitude.toStringAsFixed(1)}°',
                      style: GoogleFonts.outfit(
                        color: AppTheme.secondaryText,
                        fontSize: w * 0.028,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade().slideY(begin: 0.05),

            SizedBox(height: w * 0.03),
            Text(
              '3D Protein Structure',
              style: GoogleFonts.outfit(
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w600,
                fontSize: w * 0.045,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: w * 0.015),
            Container(
              height: w * 1.01,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.cardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.cardBorder, width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: () {
                  final String pdbStr = alert.pdbStructure;
                  final bool isFullPdb = pdbStr.length > 100 && (pdbStr.contains('ATOM') || pdbStr.contains('HEADER'));
                  if (isFullPdb) {
                    return ProteinViewer(pdbData: pdbStr);
                  }
                  
                  final String requestParam = (pdbStr.isNotEmpty && pdbStr.length < 20) ? pdbStr : alert.id;
                  
                  return FutureBuilder<String>(
                    future: Get.find<ApiService>().getStructure(requestParam),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.infoBlue,
                          ),
                        );
                      }
                      final data = snapshot.data ?? '';
                      if (data.isEmpty) {
                        return const Center(
                          child: Text(
                            'No 3D structure data available',
                            style: TextStyle(color: AppTheme.secondaryText),
                          ),
                        );
                      }
                      return ProteinViewer(pdbData: data);
                    },
                  );
                }(),
              ),
            ).animate().fade().scale(),

            SizedBox(height: w * 0.03),
            GetX<BriefController>(
              init: BriefController(),
              builder: (controller) {
                final hasBrief = controller.briefText.value.isNotEmpty;
                final isStreaming = controller.isStreaming.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'AI Analysis',
                          style: GoogleFonts.outfit(
                            color: AppTheme.secondaryText,
                            fontWeight: FontWeight.w600,
                            fontSize: w * 0.045,
                            letterSpacing: 1,
                          ),
                        ),
                        if (hasBrief || isStreaming)
                          Row(
                            children: [
                              Text(
                                'EN',
                                style: TextStyle(
                                  color: controller.language.value == 'en' ? AppTheme.infoBlue : AppTheme.secondaryText,
                                  fontWeight: controller.language.value == 'en' ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              Switch(
                                value: controller.language.value == 'ur',
                                onChanged: (_) => controller.toggleLanguageForAlert(alert),
                                activeColor: AppTheme.purpleStructural,
                              ),
                              Text(
                                'UR',
                                style: TextStyle(
                                  color: controller.language.value == 'ur' ? AppTheme.purpleStructural : AppTheme.secondaryText,
                                  fontWeight: controller.language.value == 'ur' ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    SizedBox(height: w * 0.015),
                    if (hasBrief || isStreaming)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(w * 0.04),
                        decoration: BoxDecoration(
                          color: AppTheme.cardSurface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.cardBorder, width: 1.5),
                        ),
                        child: HighlightedBriefText(
                          text: controller.briefText.value,
                          w: w,
                        ),
                      ).animate().fade().slideY(begin: 0.1),
                    if (!hasBrief && !isStreaming)
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => controller.fetchBriefForAlert(alert),
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text('Generate AI Brief'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.infoBlue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: w * 0.03),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    if (hasBrief && !isStreaming)
                      Padding(
                        padding: EdgeInsets.only(top: w * 0.02),
                        child: Center(
                          child: TextButton.icon(
                            onPressed: () => controller.fetchBriefForAlert(alert),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Regenerate Brief'),
                            style: TextButton.styleFrom(
                              foregroundColor: AppTheme.secondaryText,
                            ),
                          ),
                        ),
                      ),
                    if (isStreaming)
                      Padding(
                        padding: EdgeInsets.only(top: w * 0.02),
                        child: const Center(
                          child: CircularProgressIndicator(color: AppTheme.infoBlue),
                        ),
                      ),
                  ],
                );
              },
            ),

            SizedBox(height: w * 0.03),
            Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: false,
                title: Row(
                  children: [
                    Text(
                      'Agent Trace',
                      style: GoogleFonts.outfit(
                        color: AppTheme.secondaryText,
                        fontWeight: FontWeight.w600,
                        fontSize: w * 0.045,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.infoBlue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${filteredAgentTrace.length}',
                        style: GoogleFonts.outfit(
                          color: AppTheme.infoBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                tilePadding: EdgeInsets.zero,
                iconColor: AppTheme.secondaryText,
                collapsedIconColor: AppTheme.secondaryText,
                children: [
                  if (filteredAgentTrace.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'No trace available',
                          style: GoogleFonts.outfit(color: Colors.grey),
                        ),
                      ),
                    )
                  else ...[
                    ...List.generate(filteredAgentTrace.length, (index) {
                      final step = filteredAgentTrace[index];
                      final isLast = index == filteredAgentTrace.length - 1;
                      final stepNum = index + 1;
                      final durationMock = (1.0 + (index * 0.1)).toStringAsFixed(1) + 's';
                      final bgColor = const Color(0xFF0A0E17);
                      final cardColor = const Color(0xFF131826);
                      final accentColor = Colors.greenAccent;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: 30,
                              child: Column(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.grey.withValues(alpha: 0.5), width: 1.5),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$stepNum',
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (!isLast)
                                    Expanded(
                                      child: CustomPaint(
                                        painter: DottedLinePainter(color: Colors.grey.withValues(alpha: 0.3)),
                                        child: const SizedBox(width: 2),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(bottom: isLast ? 8.0 : 20.0),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            step.agent,
                                            style: GoogleFonts.outfit(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: accentColor.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
                                            ),
                                            child: Text(
                                              'Done',
                                              style: GoogleFonts.outfit(
                                                color: accentColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        step.action,
                                        style: GoogleFonts.outfit(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          height: 1.3,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(Icons.timer_outlined, size: 14, color: Colors.grey.withValues(alpha: 0.7)),
                                          const SizedBox(width: 4),
                                          Text(
                                            durationMock,
                                            style: GoogleFonts.outfit(
                                              color: Colors.grey.withValues(alpha: 0.7),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ).animate().fade().slideY(begin: 0.1),

            SizedBox(height: w * 0.03),
            Text(
              'Action Protocol',
              style: GoogleFonts.outfit(
                color: AppTheme.secondaryText,
                fontWeight: FontWeight.w600,
                fontSize: w * 0.045,
                letterSpacing: 1,
              ),
            ),
            SizedBox(height: w * 0.015),
            ActionPanelWidget(
              isActive: true, // Always active on detail page — action protocol always visible
              alertId: alert.id,
              threatIndex: alert.threatScore.combinedThreatIndex,
              kmerScore: alert.threatScore.kmerScore,
              esm2Score: alert.threatScore.esm2Score,
              structuralScore: alert.threatScore.structuralTmScore,
              virusName: alert.name,
              agentTrace: alert.agentTrace,
            ).animate().fade().slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  Widget _buildTraceActionCard({
    required int stepNum,
    required bool isLast,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String timestamp,
  }) {
    final bgColor = const Color(0xFF0A0E17);
    final cardColor = const Color(0xFF131826);
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 30,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.5), width: 1.5),
                  ),
                  child: Center(
                    child: Text(
                      '$stepNum',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: CustomPaint(
                      painter: DottedLinePainter(color: Colors.grey.withValues(alpha: 0.3)),
                      child: const SizedBox(width: 2),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 8.0 : 20.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              fontSize: 13,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.timer_outlined, size: 14, color: Colors.grey.withValues(alpha: 0.7)),
                              const SizedBox(width: 4),
                              Text(
                                timestamp,
                                style: GoogleFonts.outfit(
                                  color: Colors.grey.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: Colors.greenAccent, size: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  final Color color;
  DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY), Offset(size.width / 2, startY + 4), paint);
      startY += 8;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
