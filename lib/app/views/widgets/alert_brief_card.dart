import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class AlertBriefCard extends StatelessWidget {
  final String whoText;
  final String cdcText;
  final String hospitalText;
  final String mediaText;
  final String urduText;

  const AlertBriefCard({
    super.key,
    required this.whoText,
    required this.cdcText,
    required this.hospitalText,
    required this.mediaText,
    required this.urduText,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return DefaultTabController(
      length: 5,
      child: Card(
        color: AppTheme.cardSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.cardBorder),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TabBar(
                    isScrollable: true,
                    indicatorColor: AppTheme.infoBlue,
                    labelColor: AppTheme.infoBlue,
                    labelStyle: GoogleFonts.outfit(
                      color: AppTheme.infoBlue,
                      fontSize: w * 0.04,
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelColor: AppTheme.secondaryText,
                    indicatorPadding: .zero,
                    tabAlignment: TabAlignment.start,
                    tabs: [
                      Tab(text: 'WHO'),
                      Tab(text: 'CDC'),
                      Tab(text: 'Hospital'),
                      Tab(text: 'Media'),
                      Tab(text: 'Urdu'),
                    ],
                  ),
                ),
                Builder(
                  builder: (ctx) => IconButton(
                    icon: const Icon(Icons.copy, color: AppTheme.secondaryText),
                    onPressed: () {
                      final index = DefaultTabController.of(ctx).index;
                      final texts = [
                        whoText,
                        cdcText,
                        hospitalText,
                        mediaText,
                        urduText,
                      ];
                      Clipboard.setData(ClipboardData(text: texts[index]));
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
                ),
              ],
            ),
            const Divider(height: 1, color: AppTheme.cardBorder),
            SizedBox(
              height: w * 0.45,
              child: TabBarView(
                children: [
                  _buildTabContent(whoText, w: w),
                  _buildTabContent(cdcText, w: w),
                  _buildTabContent(hospitalText, w: w),
                  _buildTabContent(mediaText, w: w),
                  _buildTabContent(urduText, isRtl: true, isUrdu: true, w: w),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(
    String text, {
    bool isRtl = false,
    bool isUrdu = false,
    required double w,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: w * 0.01, horizontal: w * 0.025),
      child: SingleChildScrollView(
        child: SelectableText(
          text,
          textAlign: isRtl ? TextAlign.right : TextAlign.left,
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          style: isUrdu
              ? GoogleFonts.notoNastaliqUrdu(
                  color: AppTheme.primaryText,
                  fontSize: w * 0.035,
                  height: 2,
                )
              : GoogleFonts.outfit(
                  color: AppTheme.primaryText,
                  fontSize: w * 0.038,
                  height: 1.5,
                ),
        ),
      ),
    );
  }
}
