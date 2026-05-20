import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../models/sequence_model.dart';
import '../../theme/app_theme.dart';
import '../widgets/protein_viewer/protein_viewer.dart';
import '../../services/api_service.dart';

class ProteinStructureViewerScreen extends StatelessWidget {
  final SequenceModel sequence;

  const ProteinStructureViewerScreen({super.key, required this.sequence});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          sequence.name,
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.02),
          child: Container(
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
                final String pdbStr = sequence.pdbStructure;
                final bool isFullPdb = pdbStr.length > 100 && (pdbStr.contains('ATOM') || pdbStr.contains('HEADER'));
                if (isFullPdb) {
                  return ProteinViewer(pdbData: pdbStr, proteinName: sequence.name);
                }
                
                final String requestParam = (pdbStr.isNotEmpty && pdbStr.length < 20) ? pdbStr : sequence.id;
                
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
                    return ProteinViewer(pdbData: data, proteinName: sequence.name);
                  },
                );
              }(),
            ),
          ),
        ),
      ),
    );
  }
}
