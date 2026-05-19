import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';

class ActionPanelActions extends StatelessWidget {
  final String alertId;

  const ActionPanelActions({super.key, required this.alertId});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions Taken',
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
              _buildActionCard(
                title: 'WHO Notified',
                desc: 'Surveillance team alerted. Ref #$alertId',
                time: '14:30:12 UTC',
                icon: Icons.business,
                iconColor: AppTheme.safeGreen,
                w: w,
              ),
              SizedBox(width: w * 0.03),
              _buildActionCard(
                title: 'Travel Advisory',
                desc: 'Flag raised for origin region. Level 2 advisory.',
                time: '14:30:18 UTC',
                icon: Icons.flight_takeoff,
                iconColor: AppTheme.warningAmber,
                w: w,
              ),
              SizedBox(width: w * 0.03),
              _buildActionCard(
                title: 'Labs Shared',
                desc: 'Sequence escalated to high-priority watchlist.',
                time: '14:30:24 UTC',
                icon: Icons.science_outlined,
                iconColor: AppTheme.infoBlue,
                w: w,
              ),
            ],
          ),
        ),
      ],
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
            color: AppTheme.background.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.cardBorder),
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
              SizedBox(height: w * 0.025),
              Text(
                title,
                style: GoogleFonts.outfit(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: w * 0.032,
                ),
              ),
              SizedBox(height: w * 0.015),
              Text(
                desc,
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.026,
                  height: 1.3,
                ),
              ),
              SizedBox(height: w * 0.025),
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
