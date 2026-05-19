import 'package:crio_app/app/views/widgets/custom_navbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/responsive.dart';
import '../../theme/app_theme.dart';
import '../../controllers/shell_controller.dart';
import 'dashboard_screen.dart';
import 'analyze_screen.dart';
import 'alerts_screen.dart';
import 'agent_trace_screen.dart';
import 'replay_screen.dart';
import '../../controllers/replay_controller.dart';

class CommandCenterShell extends GetView<ShellController> {
  const CommandCenterShell({super.key});

  static const List<Widget> _screens = [
    DashboardScreen(),
    AnalyzeScreen(),
    AlertsScreen(),
    AgentTraceScreen(),
    ReplayScreen(),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Map'),
    BottomNavigationBarItem(icon: Icon(Icons.biotech), label: 'Analyze'),
    BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Alerts'),
    BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Trace'),
    BottomNavigationBarItem(
      icon: Icon(Icons.play_circle_fill),
      label: 'Replay',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Get.put(ShellController());
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Responsive(
        mobile: _buildMobileLayout(context),
        tablet: _buildTabletLayout(context),
        desktop: _buildTabletLayout(context),
      ),
      floatingActionButton: (isDesktop || isTablet)
          ? Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.infoBlue.withValues(alpha: 0.5),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: FloatingActionButton.extended(
                backgroundColor: AppTheme.infoBlue,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.white24, width: 1.5),
                ),
                icon: const Icon(Icons.play_arrow, color: AppTheme.primaryText),
                label: Text(
                  'Simulate CIRO Event',
                  style: GoogleFonts.outfit(
                    color: AppTheme.primaryText,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                ),
                onPressed: () {
                  Get.find<ReplayController>().startCovidReplay();
                },
              ),
            )
          : null,
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Stack(
      children: [
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _screens[controller.selectedIndex.value],
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          left: w * 0.05,
          right: w * 0.05,
          child: Obx(
            () => CustomTopNavbar(
              selectedIndex: controller.selectedIndex.value,
              navItems: _navItems,
              width: w,
              onIndexChanged: controller.changeIndex,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Protein Watch',
          style: GoogleFonts.outfit(
            color: AppTheme.primaryText,
            fontSize: w * 0.05,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.background.withValues(alpha: 0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _screens[controller.selectedIndex.value],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Obx(
              () => CustomBottomNavbar(
                selectedIndex: controller.selectedIndex.value,
                width: w,
                onIndexChanged: controller.changeIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
