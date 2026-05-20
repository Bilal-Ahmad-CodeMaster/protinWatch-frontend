import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/sequence_controller.dart';

class AgentTraceScreen extends StatelessWidget {
  const AgentTraceScreen({super.key});

  final Color bgColor = const Color(0xFF0A0E17);
  final Color cardColor = const Color(0xFF131826);

  @override
  Widget build(BuildContext context) {
    final SequenceController seqController = Get.find();

    return Scaffold(
      backgroundColor: Colors.transparent, // Shell provides background
      body: SafeArea(
        child: Obx(() {
          final seq = seqController.selectedSequence.value;
          if (seq == null) {
            return Center(
              child: Text(
                'No active alert selected.',
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Global Response Status',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fade().slideY(begin: 0.1),
                const SizedBox(height: 8),
                Text(
                  'Review and monitor the dissemination of threat alerts to global health bodies and partner laboratories. APIs pending integration.',
                  style: GoogleFonts.outfit(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ).animate().fade(delay: 100.ms).slideY(begin: 0.1),
                const SizedBox(height: 32),
                
                _buildActionCard(
                  icon: Icons.local_hospital,
                  iconColor: Colors.greenAccent,
                  title: 'WHO Notified',
                  description: 'Alert dispatched to WHO and regional health authorities',
                  timestamp: 'Just now',
                  delayMs: 200,
                ),
                const SizedBox(height: 16),
                
                _buildActionCard(
                  icon: Icons.flight_takeoff,
                  iconColor: Colors.orangeAccent,
                  title: 'Travel Advisory',
                  description: 'Travel advisory protocols initiated for the region',
                  timestamp: '2 mins ago',
                  delayMs: 300,
                ),
                const SizedBox(height: 16),
                
                _buildActionCard(
                  icon: Icons.science,
                  iconColor: Colors.lightBlueAccent,
                  title: 'Labs Shared',
                  description: 'Sequence data shared with global research laboratories',
                  timestamp: '5 mins ago',
                  delayMs: 400,
                ),
                
                const SizedBox(height: 120), // Padding for bottom navbar
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required String timestamp,
    required int delayMs,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
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
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey.withValues(alpha: 0.6)),
                    const SizedBox(width: 4),
                    Text(
                      timestamp,
                      style: GoogleFonts.outfit(
                        color: Colors.grey.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
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
    ).animate().fade(delay: Duration(milliseconds: delayMs)).slideX(begin: 0.1, delay: Duration(milliseconds: delayMs));
  }
}
