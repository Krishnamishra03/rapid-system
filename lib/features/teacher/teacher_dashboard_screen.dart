import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';
import '../attendant/qr_scanner_screen.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final user = appState.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Teacher Class Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.accent),
            tooltip: 'Scan Student QR',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrScannerScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning, ${user.name.split(' ')[0]} 👋',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
            const SizedBox(height: 4),
            const Text(
              'Class Educator & Safety Telemetry Coordinator',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Class Summary Hero Card (Deep Obsidian Slate)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppColors.primaryGlowShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ASSIGNED CLASS',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Class ${user.assignedClass ?? '8-A'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      CircularPercentIndicator(
                        radius: 38.0,
                        lineWidth: 8.0,
                        percent: 0.90,
                        center: const Text(
                          '90%',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 15.0,
                            color: Colors.white,
                          ),
                        ),
                        progressColor: AppColors.success,
                        backgroundColor: Colors.white24,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStat('Total', '40 Students', Colors.white),
                      _buildStat('Present', '36 Students', AppColors.success),
                      _buildStat('Absent', '4 Students', AppColors.danger),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),

            // Primary Take Attendance CTA Button (Neumorphic Card Wrapper)
            NeumorphicCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(6),
              child: AppButton(
                text: 'TAKE CLASSROOM ATTENDANCE',
                icon: Icons.rule_folder_rounded,
                type: AppButtonType.secondary,
                height: 56,
                onPressed: () {
                  context.go('/teacher/attendance');
                },
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 28),

            const Text(
              'Quick Class Overview',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 14),

            _buildClassCard(context, 'Class 8-A', '40 Students', '90% Attendance Today', true),
            _buildClassCard(context, 'Class 8-B', '38 Students', '89% Attendance Today', false),
            _buildClassCard(context, 'Class 9-A', '42 Students', '95% Attendance Today', false),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String title, String val, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(color: valColor, fontSize: 14, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildClassCard(BuildContext context, String title, String count, String status, bool isAssigned) {
    return NeumorphicCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      onTap: () {
        context.go('/teacher/attendance');
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: isAssigned ? AppColors.accentGradient : null,
              color: isAssigned ? null : AppColors.surfaceSubtle,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.school, color: isAssigned ? Colors.white : AppColors.textMuted, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                const SizedBox(height: 2),
                Text('$count • $status', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
        ],
      ),
    );
  }
}
