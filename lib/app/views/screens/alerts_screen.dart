import 'package:crio_app/app/views/screens/alert_screen_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../controllers/sequence_controller.dart';
import '../../controllers/resource_controller.dart';
import '../../models/sequence_model.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ResourceController resourceController =
        Get.find<ResourceController>();
    final SequenceController sequenceController =
        Get.find<SequenceController>();
    final w = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(() {
          final assignments = resourceController.assignments;

          if (assignments.isEmpty) {
            return Center(
              child: Text(
                'No alerts found.',
                style: GoogleFonts.outfit(
                  color: AppTheme.secondaryText,
                  fontSize: w * 0.035,
                ),
              ),
            );
          }

          final hasConflict = resourceController.hasConflict.value;
          final List<SequenceModel> historyList = sequenceController.sequences;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.04,
                  vertical: w * 0.02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Resource Distribution',
                            style: GoogleFonts.outfit(
                              color: AppTheme.primaryText,
                              fontSize: w * 0.05,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ).animate().fade().slideY(begin: -0.2),
                          Text(
                            'Real-time threat status and deployment command center',
                            style: GoogleFonts.outfit(
                              color: AppTheme.secondaryText,
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.w400,
                            ),
                          ).animate().fade().slideY(begin: -0.2),
                        ],
                      ),
                    ),
                    Obx(() {
                      final isActive = resourceController.isDemoActive.value;
                      return TextButton.icon(
                        onPressed: () => resourceController.toggleDemo(),
                        icon: Icon(
                          isActive ? Icons.restart_alt : Icons.bolt,
                          color: isActive
                              ? const Color(0xFF00FF88)
                              : const Color(0xFFFF5555),
                          size: 16,
                        ),
                        label: Text(
                          isActive ? 'Reset Demo' : 'Simulate Conflict',
                          style: GoogleFonts.outfit(
                            color: isActive
                                ? const Color(0xFF00FF88)
                                : const Color(0xFFFF5555),
                            fontWeight: FontWeight.bold,
                            fontSize: w * 0.028,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              (isActive
                                      ? const Color(0xFF00FF88)
                                      : const Color(0xFFFF5555))
                                  .withValues(alpha: 0.12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Conflict Banner (FULL WIDTH, NO PADDING, IMPOSSIBLE TO MISS)
              if (hasConflict) ...[
                _buildConflictBanner(w, resourceController),
                SizedBox(height: w * 0.02),
              ],

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + w * 0.2,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TOP ROW - 3 resource pool cards
                        Row(
                          children: [
                            // WHO Teams Card
                            Expanded(
                              child: Obx(() {
                                final count =
                                    resourceController.whoTeamsAvailable.value;
                                Color color;
                                String warningText = '';
                                if (count == 0) {
                                  color = const Color(0xFFFF4444);
                                  warningText = '⚠️ All Deployed';
                                } else if (count == 3) {
                                  color = const Color(0xFF00FF88);
                                } else {
                                  color = const Color(0xFFFF4444);
                                }
                                return _buildPoolCard(
                                  w,
                                  label: 'WHO Teams',
                                  valueText: '$count/3 Available',
                                  progressValue: count / 3.0,
                                  color: color,
                                  warningText: warningText,
                                );
                              }),
                            ),
                            SizedBox(width: w * 0.02),

                            // Labs Card
                            Expanded(
                              child: Obx(() {
                                final count = resourceController
                                    .labNetworksAvailable
                                    .value;
                                Color color;
                                String warningText = '';
                                if (count == 0) {
                                  color = const Color(0xFFFF4444);
                                  warningText = '⚠️ All Deployed';
                                } else if (count == 5) {
                                  color = const Color(0xFF00FF88);
                                } else {
                                  color = const Color(0xFF00FF88);
                                }
                                return _buildPoolCard(
                                  w,
                                  label: 'Labs',
                                  valueText: '$count/5 Available',
                                  progressValue: count / 5.0,
                                  color: color,
                                  warningText: warningText,
                                );
                              }),
                            ),
                            SizedBox(width: w * 0.02),

                            // Travel Alerts Card
                            Expanded(
                              child: Obx(() {
                                final count = resourceController
                                    .travelAlertsAvailable
                                    .value;
                                Color color;
                                String warningText = '';
                                if (count == 0) {
                                  color = const Color(0xFFFF4444);
                                  warningText = '⚠️ All Deployed';
                                } else if (count == 2) {
                                  color = const Color(0xFF00FF88);
                                } else {
                                  color = const Color(0xFFFFA500);
                                }
                                return _buildPoolCard(
                                  w,
                                  label: 'Travel Alerts',
                                  valueText: '$count/2 Available',
                                  progressValue: count / 2.0,
                                  color: color,
                                  warningText: warningText,
                                );
                              }),
                            ),
                          ],
                        ).animate().fade().slideY(begin: 0.1),
                        SizedBox(height: w * 0.05),

                        // PRIORITY QUEUE LIST
                        Text(
                          'Priority Command Queue',
                          style: GoogleFonts.outfit(
                            color: AppTheme.secondaryText,
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: w * 0.02),
                        ...List.generate(assignments.length, (index) {
                          final assignment = assignments[index];
                          return _buildPriorityAssignmentRow(
                            context,
                            w,
                            assignment,
                            index,
                          );
                        }),

                        SizedBox(height: w * 0.05),

                        // Section 2: Recent History
                        Text(
                          'Recent History',
                          style: GoogleFonts.outfit(
                            color: AppTheme.secondaryText,
                            fontSize: w * 0.035,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: w * 0.02),
                        ...List.generate(historyList.length, (index) {
                          final alert = historyList[index];
                          final score = alert.threatScore.combinedThreatIndex;
                          final isCritical = score > 75;
                          final color = isCritical
                              ? const Color(0xFFFF4444)
                              : (score >= 50
                                    ? const Color(0xFFFFA500)
                                    : const Color(0xFF00FF88));

                          return GestureDetector(
                                onTap: () {
                                  Get.to(() => AlertDetailsPage(alert: alert));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: w * 0.03),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: w * 0.04,
                                    vertical: w * 0.02,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.cardSurface.withValues(
                                      alpha: 0.9,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: color.withValues(alpha: 0.35),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 1. Header row
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  alert.name,
                                                  style: GoogleFonts.outfit(
                                                    color: AppTheme.primaryText,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: w * 0.04,
                                                  ),
                                                ),
                                                SizedBox(height: w * 0.005),
                                                Text(
                                                  '${alert.originLocation} · ${DateFormat('MMM dd yyyy').format(alert.detectionDate)}',
                                                  style: GoogleFonts.outfit(
                                                    color:
                                                        AppTheme.secondaryText,
                                                    fontSize: w * 0.03,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: '$score',
                                              style: GoogleFonts.outfit(
                                                color: color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: w * 0.05,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '/100',
                                                  style: GoogleFonts.outfit(
                                                    color: AppTheme.primaryText
                                                        .withValues(alpha: 0.7),
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: w * 0.035,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      // 2. Metrics (Progress bars) - only for Critical or Monitor
                                      if (score >= 50) ...[
                                        SizedBox(height: w * 0.02),
                                        _buildMetricRow(
                                          w,
                                          label: 'K-mer',
                                          value: alert.threatScore.kmerScore,
                                          color: AppTheme.infoBlue,
                                        ),
                                        SizedBox(height: w * 0.01),
                                        _buildMetricRow(
                                          w,
                                          label: 'ESM-2',
                                          value: alert.threatScore.esm2Score,
                                          color: color,
                                        ),
                                      ],

                                      SizedBox(height: w * 0.02),
                                      _buildStatusBadge(w, alert, score),
                                    ],
                                  ),
                                ),
                              )
                              .animate()
                              .fade(delay: Duration(milliseconds: 100 * index))
                              .slideY(begin: 0.1);
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPoolCard(
    double w, {
    required String label,
    required String valueText,
    required double progressValue,
    required Color color,
    required String warningText,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: w * 0.025),
      decoration: BoxDecoration(
        color: AppTheme.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.cardBorder, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: AppTheme.secondaryText,
              fontSize: w * 0.026,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: w * 0.01),
          Text(
            valueText,
            style: GoogleFonts.outfit(
              color: color,
              fontSize: w * 0.038,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (warningText.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              warningText,
              style: GoogleFonts.outfit(
                color: const Color(0xFFFF4444),
                fontSize: w * 0.022,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          SizedBox(height: w * 0.015),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 6,
              backgroundColor: AppTheme.background,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConflictBanner(double w, ResourceController controller) {
    final nextQueued = controller.getFirstQueuedThreatName() ?? 'Novel-H7N2';
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF8B0000), // Dark Red background
        border: Border(
          left: BorderSide(
            color: Color(0xFFFF4444), // Bright Red left border (6px)
            width: 6,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: w * 0.04, vertical: w * 0.035),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '⚠️ RESOURCE CONFLICT — All WHO Teams Deployed',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: w * 0.035,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Target Threat for Action: "$nextQueued"',
            style: GoogleFonts.outfit(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: w * 0.026,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildBannerButton(
                  w,
                  label: 'Queue',
                  onPressed: () {
                    controller.resolveConflict('queue');
                    Get.closeAllSnackbars();
                    Get.snackbar(
                      'Conflict Queued',
                      '$nextQueued added to response queue. WHO Team notified.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF131826),
                      colorText: Colors.white,
                      icon: const Icon(Icons.queue, color: Color(0xFF8892A0)),
                      borderWidth: 1,
                      borderColor: const Color(
                        0xFF8892A0,
                      ).withValues(alpha: 0.3),
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                  textColor: const Color(0xFF8892A0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBannerButton(
                  w,
                  label: 'Split Resources',
                  onPressed: () {
                    controller.resolveConflict('split');
                    Get.closeAllSnackbars();
                    Get.snackbar(
                      'Conflict Split',
                      'Partial WHO Team dispatched to $nextQueued. Capacity at 50%.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF131826),
                      colorText: Colors.white,
                      icon: const Icon(
                        Icons.call_split,
                        color: Color(0xFFFFA500),
                      ),
                      borderWidth: 1,
                      borderColor: const Color(
                        0xFFFFA500,
                      ).withValues(alpha: 0.3),
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                  textColor: const Color(0xFFFFA500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildBannerButton(
                  w,
                  label: 'Escalate to HQ',
                  onPressed: () {
                    controller.resolveConflict('escalate');
                    Get.closeAllSnackbars();
                    Get.snackbar(
                      'Conflict Escalated',
                      '🚨 WHO Emergency Committee alerted. Response incoming.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: const Color(0xFF131826),
                      colorText: Colors.white,
                      icon: const Icon(
                        Icons.campaign,
                        color: Color(0xFFFF4444),
                      ),
                      borderWidth: 1,
                      borderColor: const Color(
                        0xFFFF4444,
                      ).withValues(alpha: 0.3),
                      margin: const EdgeInsets.all(16),
                      borderRadius: 12,
                    );
                  },
                  textColor: const Color(0xFFFF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fade().shake(duration: 500.ms);
  }

  Widget _buildBannerButton(
    double w, {
    required String label,
    required VoidCallback onPressed,
    required Color textColor,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: const BorderSide(color: Colors.white, width: 1.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: w * 0.025),
        backgroundColor: Colors.white.withValues(alpha: 0.05),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: w * 0.024,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildPriorityAssignmentRow(
    BuildContext context,
    double w,
    ResourceAssignment assignment,
    int index,
  ) {
    final score = assignment.threatScore.toInt();

    // Threat colors and badge text
    Color threatColor;
    String badgeText;
    if (score > 75) {
      threatColor = const Color(0xFFFF4444);
      badgeText = 'CRITICAL';
    } else if (score >= 50) {
      threatColor = const Color(0xFFFFA500);
      badgeText = 'MONITOR';
    } else {
      threatColor = const Color(0xFF00FF88);
      badgeText = 'SAFE';
    }

    // Status chip color
    Color statusColor;
    switch (assignment.status) {
      case 'QUEUED':
        statusColor = const Color(0xFF8892A0);
        break;
      case 'ESCALATED':
        statusColor = const Color(0xFFFF4444);
        break;
      case 'SPLIT':
        statusColor = const Color(0xFFFFA500);
        break;
      case 'ACTIVE':
      default:
        statusColor = const Color(0xFF00FF88);
        break;
    }

    // Dynamic descriptive text based on state (Fix 2)
    String resourceText;
    if (assignment.status == 'QUEUED') {
      resourceText = '⏳ Waiting for WHO Team availability • Est. 4h delay';
    } else if (assignment.status == 'SPLIT') {
      resourceText = '⚠️ Partial WHO Team deployed • Reduced response capacity';
    } else if (assignment.status == 'ESCALATED') {
      resourceText = '🚨 Escalated to WHO Emergency Committee • HQ notified';
    } else {
      // ACTIVE
      if (score > 75) {
        final who = assignment.assignedWHO != 'None'
            ? assignment.assignedWHO
            : 'WHO Team A';
        final lab = assignment.assignedLab != 'None'
            ? assignment.assignedLab
            : 'Lab Network 1';
        resourceText = '$who assigned • $lab • Travel Alert issued';
      } else if (score >= 50) {
        final lab = assignment.assignedLab != 'None'
            ? assignment.assignedLab
            : 'Lab Network 1';
        resourceText = '$lab assigned • Lab monitoring active';
      } else {
        resourceText = 'Watchlist active • Monitoring only';
      }
    }

    return GestureDetector(
      onTap: () {
        Get.to(() => AlertDetailsPage(alert: assignment.sequence));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: w * 0.025),
        constraints: const BoxConstraints(minHeight: 80),
        decoration: BoxDecoration(
          color: AppTheme.cardSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.cardBorder, width: 1.2),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Subtle left border color accent matching threat level color
              Container(width: 5, color: threatColor),

              // Row content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: w * 0.035,
                    vertical: w * 0.02,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // LEFT: Threat badge (Circle + Text)
                      SizedBox(
                        width: w * 0.15,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: w * 0.08,
                              height: w * 0.08,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: threatColor.withValues(alpha: 0.12),
                                border: Border.all(
                                  color: threatColor,
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$score',
                                style: GoogleFonts.outfit(
                                  color: threatColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.028,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              badgeText,
                              style: GoogleFonts.outfit(
                                color: threatColor,
                                fontWeight: FontWeight.w800,
                                fontSize: w * 0.018,
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: w * 0.03),

                      // MIDDLE: Virus name + dynamic status text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              assignment.virusName,
                              style: GoogleFonts.outfit(
                                color: AppTheme.primaryText,
                                fontWeight: FontWeight.bold,
                                fontSize: w * 0.034,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              resourceText,
                              style: GoogleFonts.outfit(
                                color: Colors.grey,
                                fontSize: w * 0.026,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: w * 0.02),

                      // RIGHT: Status chip with pulsing/warning animations (Fix 3)
                      _buildAnimatedStatusChip(
                        w,
                        assignment.status,
                        statusColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: Duration(milliseconds: 50 * index)).slideY(begin: 0.05);
  }

  Widget _buildAnimatedStatusChip(double w, String status, Color statusColor) {
    final Widget chipContent = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (status == 'ESCALATED') ...[
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFF4444),
            size: 11,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          status,
          style: GoogleFonts.outfit(
            color: statusColor,
            fontSize: w * 0.022,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );

    final Widget container = Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.025, vertical: w * 0.008),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: chipContent,
    );

    if (status == 'QUEUED') {
      return container
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fade(begin: 0.5, end: 1.0, duration: 1200.ms);
    } else if (status == 'SPLIT') {
      return container
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fade(begin: 0.5, end: 1.0, duration: 1200.ms);
    } else if (status == 'ESCALATED') {
      return container
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fade(begin: 0.3, end: 1.0, duration: 500.ms);
    } else {
      return container;
    }
  }

  Widget _buildMetricRow(
    double w, {
    required String label,
    required int value,
    required Color color,
  }) {
    return Row(
      children: [
        SizedBox(
          width: w * 0.14,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: AppTheme.secondaryText,
              fontSize: w * 0.032,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 6,
              backgroundColor: AppTheme.background,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        SizedBox(width: w * 0.04),
        SizedBox(
          width: w * 0.06,
          child: Text(
            '$value',
            style: GoogleFonts.outfit(
              color: color,
              fontSize: w * 0.032,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(double w, SequenceModel alert, int score) {
    String text = '';
    Color color = Colors.transparent;

    final isCritical = score > 75;
    if (isCritical) {
      final alertId = alert.alert?.alertId ?? 'PW-2019-001';
      text = 'ALERT DISPATCHED · $alertId';
      color = AppTheme.criticalRed;
    } else if (score >= 50) {
      text = 'MONITORING — no action';
      color = AppTheme.warningAmber;
    } else {
      text = 'SAFE — no action required';
      color = AppTheme.safeGreen;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: w * 0.01),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: color,
          fontSize: w * 0.024,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
