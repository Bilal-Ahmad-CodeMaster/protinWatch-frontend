import 'package:crio_app/app/models/sequence_model.dart';
import 'package:crio_app/app/theme/app_theme.dart';
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

  List<AgentStepModel> getTraceSteps(SequenceModel alert) {
    final int score = alert.threatScore.combinedThreatIndex;
    if (score > 75) {
      return [
        AgentStepModel(
          agent: 'DetectionAgent',
          action: "Threat Index $score/100 - threshold exceeded",
          timestamp: '14:30:05 UTC - 0.4s',
          color: 'blue',
        ),
        AgentStepModel(
          agent: 'VerificationAgent',
          action: "AlphaFold structural confirmation checked",
          timestamp: '14:30:07 UTC - 1.2s',
          color: 'purple',
        ),
        AgentStepModel(
          agent: 'ResponseAgent',
          action: "Alert ${alert.id} created and dispatched",
          timestamp: '14:30:09 UTC - 0.1s',
          color: 'red',
        ),
        AgentStepModel(
          agent: 'NotificationAgent',
          action: "WHO + stakeholders notified",
          timestamp: '14:30:10 UTC - 0.2s',
          color: 'green',
        ),
      ];
    } else if (score >= 50) {
      return [
        AgentStepModel(
          agent: 'DetectionAgent',
          action: "Threat Index $score/100 - under critical threshold",
          timestamp: '14:30:05 UTC - 0.4s',
          color: 'blue',
        ),
        AgentStepModel(
          agent: 'MonitoringAgent',
          action: "Sequence added to surveillance watchlist. No immediate action required.",
          timestamp: '14:30:07 UTC - 0.8s',
          color: 'orange',
        ),
      ];
    } else {
      return [
        AgentStepModel(
          agent: 'DetectionAgent',
          action: "Threat Index $score/100 - classified as safe. No action required.",
          timestamp: '14:30:05 UTC - 0.4s',
          color: 'blue',
        ),
      ];
    }
  }


  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final int score = alert.threatScore.combinedThreatIndex;
    final isCritical = score > 75;
    final isMonitor = score >= 50 && score <= 75;
    final levelText = isCritical ? 'CRITICAL' : (isMonitor ? 'MONITOR' : 'SAFE');
    final levelColor = isCritical ? AppTheme.criticalRed : (isMonitor ? AppTheme.warningAmber : AppTheme.safeGreen);

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
        padding: EdgeInsets.only(
          left: w * 0.04,
          right: w * 0.04,
          top: w * 0.02,
          bottom: MediaQuery.of(context).padding.bottom + w * 0.04,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unified Action Protocol Card
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF131826),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder, width: 1.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (isCritical)
                      Container(
                        width: 6,
                        color: AppTheme.criticalRed,
                      ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(w * 0.04),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Top row: Alert ID + DISPATCHED badge + Threat Index
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      alert.id,
                                      style: GoogleFonts.outfit(
                                        color: AppTheme.secondaryText,
                                        fontWeight: FontWeight.bold,
                                        fontSize: w * 0.032,
                                      ),
                                    ),
                                    SizedBox(width: w * 0.02),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.infoBlue.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppTheme.infoBlue.withValues(alpha: 0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        'DISPATCHED',
                                        style: GoogleFonts.outfit(
                                          color: AppTheme.infoBlue,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: '$score',
                                    style: GoogleFonts.outfit(
                                      color: levelColor,
                                      fontWeight: FontWeight.w800,
                                      fontSize: w * 0.055,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '/100',
                                        style: GoogleFonts.outfit(
                                          color: AppTheme.secondaryText,
                                          fontSize: w * 0.03,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: w * 0.02),

                            // 2. Virus name + Level badge
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    alert.name,
                                    style: GoogleFonts.outfit(
                                      color: AppTheme.primaryText,
                                      fontWeight: FontWeight.bold,
                                      fontSize: w * 0.045,
                                    ),
                                  ),
                                ),
                                SizedBox(width: w * 0.02),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: levelColor.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: levelColor.withValues(alpha: 0.4),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    levelText,
                                    style: GoogleFonts.outfit(
                                      color: levelColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            Divider(height: w * 0.06, color: AppTheme.cardBorder, thickness: 1.5),

                            // 3. AI Layers Section
                            Text(
                              'AI LAYERS',
                              style: GoogleFonts.outfit(
                                color: AppTheme.secondaryText.withValues(alpha: 0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.028,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: w * 0.025),
                            Row(
                              children: [
                                _buildProgressIndicator(
                                  label: 'K-mer',
                                  value: alert.threatScore.kmerScore / 100,
                                  color: AppTheme.infoBlue,
                                  w: w,
                                ),
                                SizedBox(width: w * 0.03),
                                _buildProgressIndicator(
                                  label: 'ESM-2',
                                  value: alert.threatScore.esm2Score / 100,
                                  color: AppTheme.warningAmber,
                                  w: w,
                                ),
                                SizedBox(width: w * 0.03),
                                _buildProgressIndicator(
                                  label: 'Structural',
                                  value: alert.threatScore.structuralTmScore,
                                  color: AppTheme.purpleStructural,
                                  w: w,
                                ),
                              ],
                            ),

                            if (score >= 50) ...[
                              Divider(height: w * 0.06, color: AppTheme.cardBorder, thickness: 1.5),

                              // 4. Actions Taken Section
                              Text(
                                'ACTIONS TAKEN',
                                style: GoogleFonts.outfit(
                                  color: AppTheme.secondaryText.withValues(alpha: 0.7),
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.028,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: w * 0.025),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (score > 75) ...[
                                      _buildActionCard(
                                        title: 'WHO Notified',
                                        desc: 'Surveillance team alerted. Ref #${alert.id}',
                                        time: '14:30:12 UTC',
                                        icon: Icons.business,
                                        iconColor: AppTheme.safeGreen,
                                        w: w,
                                      ),
                                      SizedBox(width: w * 0.025),
                                      _buildActionCard(
                                        title: 'Travel Advisory',
                                        desc: 'Flag raised for origin region. Level 2 advisory.',
                                        time: '14:30:18 UTC',
                                        icon: Icons.flight_takeoff,
                                        iconColor: AppTheme.warningAmber,
                                        w: w,
                                      ),
                                      SizedBox(width: w * 0.025),
                                      _buildActionCard(
                                        title: 'Labs Shared',
                                        desc: 'Sequence escalated to high-priority watchlist.',
                                        time: '14:30:24 UTC',
                                        icon: Icons.science_outlined,
                                        iconColor: AppTheme.infoBlue,
                                        w: w,
                                      ),
                                    ] else if (score >= 50) ...[
                                      _buildActionCard(
                                        title: 'Surveillance Watchlist',
                                        desc: 'Sequence added to surveillance watchlist. No immediate action required.',
                                        time: '14:30:24 UTC',
                                        icon: Icons.visibility,
                                        iconColor: AppTheme.infoBlue,
                                        w: w,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],

                            Divider(height: w * 0.06, color: AppTheme.cardBorder, thickness: 1.5),

                            // 5. Agent Trace Section (Always visible, inside this card)
                            Text(
                              'AGENT TRACE',
                              style: GoogleFonts.outfit(
                                color: AppTheme.secondaryText.withValues(alpha: 0.7),
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.028,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: w * 0.025),
                            Column(
                              children: [
                                ...List.generate(getTraceSteps(alert).length, (index) {
                                  final steps = getTraceSteps(alert);
                                  final step = steps[index];
                                  final isLast = index == steps.length - 1;
                                  final stepNum = index + 1;
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
                                                  color: const Color(0xFF0A0E17),
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey.withValues(alpha: 0.5),
                                                    width: 1.5,
                                                  ),
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
                                                    painter: DottedLinePainter(
                                                      color: Colors.grey.withValues(alpha: 0.3),
                                                    ),
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
                                                color: const Color(0xFF0A0E17).withValues(alpha: 0.4),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: Colors.white.withValues(alpha: 0.05),
                                                ),
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
                                                          fontSize: w * 0.034,
                                                        ),
                                                      ),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration: BoxDecoration(
                                                          color: accentColor.withValues(alpha: 0.1),
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(
                                                            color: accentColor.withValues(alpha: 0.3),
                                                          ),
                                                        ),
                                                        child: Text(
                                                          'Done',
                                                          style: GoogleFonts.outfit(
                                                            color: accentColor,
                                                            fontSize: 11,
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
                                                      fontSize: w * 0.03,
                                                      height: 1.3,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.timer_outlined,
                                                        size: 14,
                                                        color: Colors.grey.withValues(alpha: 0.7),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        step.timestamp,
                                                        style: GoogleFonts.outfit(
                                                          color: Colors.grey.withValues(alpha: 0.7),
                                                          fontSize: 11,
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
                                if (score >= 50 && score <= 75) ...[
                                  SizedBox(height: w * 0.02),
                                  Container(
                                    padding: EdgeInsets.all(w * 0.03),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          'ℹ️',
                                          style: TextStyle(fontSize: w * 0.04),
                                        ),
                                        SizedBox(width: w * 0.02),
                                        Expanded(
                                          child: Text(
                                            'Threat level does not require WHO notification or resource dispatch',
                                            style: GoogleFonts.outfit(
                                              color: Colors.grey[400],
                                              fontSize: w * 0.03,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ] else if (score < 50) ...[
                                  SizedBox(height: w * 0.02),
                                  Container(
                                    padding: EdgeInsets.all(w * 0.03),
                                    decoration: BoxDecoration(
                                      color: AppTheme.safeGreen.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: AppTheme.safeGreen.withValues(alpha: 0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '✅',
                                          style: TextStyle(fontSize: w * 0.04),
                                        ),
                                        SizedBox(width: w * 0.02),
                                        Expanded(
                                          child: Text(
                                            'Sequence is safe. Monitoring continues normally.',
                                            style: GoogleFonts.outfit(
                                              color: AppTheme.safeGreen,
                                              fontSize: w * 0.03,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fade().scale(),
            
            SizedBox(height: w * 0.04),

            // Origin Location card
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.04,
                vertical: w * 0.03,
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

            SizedBox(height: w * 0.04),
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

            SizedBox(height: w * 0.04),
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
                                activeThumbColor: AppTheme.purpleStructural,
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
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator({
    required String label,
    required double value,
    required Color color,
    required double w,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.028,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${(value > 1.0 ? value : value * 100).toInt()}%',
                style: GoogleFonts.outfit(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.028,
                ),
              ),
            ],
          ),
          SizedBox(height: w * 0.015),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 6,
              backgroundColor: const Color(0xFF0A0E17),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required String time,
    required IconData icon,
    required Color iconColor,
    required double w,
  }) {
    final cardWidth = (w * 0.52).clamp(180.0, 240.0);
    return Stack(
      children: [
        Container(
          width: cardWidth,
          padding: EdgeInsets.all(w * 0.03),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0E17).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(w * 0.015),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: w * 0.045),
              ),
              SizedBox(height: w * 0.02),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.032,
                ),
              ),
              SizedBox(height: w * 0.01),
              Text(
                desc,
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.026,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: w * 0.02),
              Text(
                time,
                style: GoogleFonts.outfit(
                  color: AppTheme.mutedText,
                  fontSize: w * 0.024,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: w * 0.025,
          right: w * 0.025,
          child: Icon(
            Icons.check_circle,
            color: AppTheme.safeGreen,
            size: w * 0.038,
          ),
        ),
      ],
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
