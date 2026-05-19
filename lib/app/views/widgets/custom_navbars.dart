import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class CustomTopNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<BottomNavigationBarItem> navItems;
  final double width;

  const CustomTopNavbar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.navItems,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Container(
      height: w * 0.2,
      decoration: AppTheme.glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(w * 0.1),
        color: AppTheme.cardSurface.withValues(alpha: 0.75),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(w * 0.1),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 1. App Logo
              Padding(
                padding: .only(left: w * 0.05),
                child: Row(
                  children: [
                    Container(
                          padding: EdgeInsets.all(w * 0.01),
                          decoration: BoxDecoration(
                            color: AppTheme.infoBlue.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.infoBlue.withValues(alpha: 0.3),
                                blurRadius: w * 0.015,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .shimmer(duration: const Duration(seconds: 3)),
                    SizedBox(width: w * 0.03),
                    if (width > 800)
                      Text(
                        'Protein Watch',
                        style: GoogleFonts.outfit(
                          color: AppTheme.primaryText,
                          fontWeight: FontWeight.w900,
                          letterSpacing: w * 0.05,
                          fontSize: w * 0.03,
                        ),
                      ),
                  ],
                ),
              ),

              // 2. Centered Nav Items
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: .min,
                    mainAxisAlignment: .center,
                    children: navItems.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final item = entry.value;
                      final isSelected = selectedIndex == idx;
                      final activeColor = AppTheme.infoBlue;

                      return GestureDetector(
                        behavior: .opaque,
                        onTap: () => onIndexChanged(idx),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: EdgeInsets.symmetric(horizontal: w * 0.01),
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.04,
                            vertical: w * 0.025,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? activeColor.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? activeColor.withValues(alpha: 0.5)
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: activeColor.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                    ),
                                  ]
                                : [],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                (item.icon as Icon).icon,
                                color: isSelected
                                    ? activeColor
                                    : AppTheme.secondaryText,
                                size: 20,
                              ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                Text(
                                  item.label ?? '',
                                  style: GoogleFonts.outfit(
                                    color: activeColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: w * 0.03,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // 3. Actions
              Padding(
                padding: .only(right: w * 0.05),
                child: Row(
                  children: [
                    Container(
                          width: w * 0.02,
                          height: w * 0.02,
                          decoration: const BoxDecoration(
                            color: AppTheme.safeGreen,
                            shape: BoxShape.circle,
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .fade(duration: const Duration(seconds: 1)),
                    SizedBox(width: w * 0.02),
                    Text(
                      'Data Sync',
                      style: GoogleFonts.outfit(
                        color: AppTheme.safeGreen,
                        fontWeight: FontWeight.w800,
                        fontSize: w * 0.03,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final double width;

  const CustomBottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    final primaryTabs = [
      {'index': 0, 'icon': Icons.public, 'label': 'Map'},
      {'index': 1, 'icon': Icons.biotech, 'label': 'Analyze'},
      {'index': 2, 'icon': Icons.warning, 'label': 'Alerts'},
      {'index': 3, 'icon': Icons.timeline, 'label': 'Trace'},
      {'index': 4, 'icon': Icons.play_circle_fill, 'label': 'Replay'},
    ];

    return Container(
      height: w * 0.2,
      margin: EdgeInsets.only(
        left: width * 0.04,
        right: width * 0.04,
        bottom: MediaQuery.of(context).padding.bottom + w * 0.025,
      ),
      decoration: AppTheme.glassDecoration.copyWith(
        borderRadius: .circular(35),
        color: AppTheme.cardSurface.withValues(alpha: 0.85),
      ),
      child: ClipRRect(
        borderRadius: .circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...primaryTabs.map((tab) {
                final idx = tab['index'] as int;
                final isSelected = selectedIndex == idx;
                final activeColor = AppTheme.infoBlue;

                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onIndexChanged(idx),
                  child: Padding(
                    padding: .symmetric(
                      horizontal: w * 0.025,
                      vertical: w * 0.02,
                    ),
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(
                          tab['icon'] as IconData,
                          color: isSelected
                              ? activeColor
                              : AppTheme.secondaryText,
                          size: w * 0.07,
                        ),
                        SizedBox(height: w * 0.01),
                        Text(
                          tab['label'] as String,
                          style: GoogleFonts.outfit(
                            color: isSelected
                                ? activeColor
                                : AppTheme.secondaryText,
                            fontSize: w * 0.02,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
