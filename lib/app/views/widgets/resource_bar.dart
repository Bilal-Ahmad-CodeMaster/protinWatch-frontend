import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/resource_model.dart';

class ResourceBar extends StatelessWidget {
  final ResourceModel resource;
  
  const ResourceBar({super.key, required this.resource});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final h = MediaQuery.sizeOf(context).height;
    final ratio = resource.deployed / (resource.total == 0 ? 1 : resource.total);
    final color = ratio > 0.8 
        ? AppTheme.criticalRed 
        : (ratio > 0.5 ? AppTheme.warningAmber : AppTheme.safeGreen);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: h * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resource.name.toUpperCase(), 
                style: GoogleFonts.outfit(
                  color: AppTheme.primaryText,
                  fontWeight: FontWeight.w700, 
                  letterSpacing: 1.1,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.002),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
                child: Text(
                  '${resource.deployed} / ${resource.total}', 
                  style: GoogleFonts.outfit(
                    color: color, 
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: h * 0.01),
          Container(
            height: h * 0.012,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 2))
              ]
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: AppTheme.cardBorder,
                color: color,
              ),
            ),
          ).animate().slideX(begin: -1, duration: const Duration(milliseconds: 800), curve: Curves.easeOutQuart),
        ],
      ),
    );
  }
}
