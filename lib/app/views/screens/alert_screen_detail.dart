import 'package:crio_app/app/models/sequence_model.dart';
import 'package:crio_app/app/theme/app_theme.dart';
import 'package:crio_app/app/views/widgets/action_panel/action_panel.dart';
import 'package:crio_app/app/views/widgets/threat/threat_score_card.dart';
import 'package:crio_app/app/views/widgets/protein_viewer/protein_viewer.dart';
import 'package:crio_app/app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class AlertDetailsPage extends StatelessWidget {
  final SequenceModel alert;

  const AlertDetailsPage({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
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
              isActive: alert.threatScore.combinedThreatIndex >= 75 || alert.threatScore.esm2Score >= 61,
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
}
