import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/emergency_sos_dialog.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';
import 'qr_scanner_screen.dart';

class AttendantHomeScreen extends StatelessWidget {
  const AttendantHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final user = appState.currentUser;
    final bus = appState.busInfo;
    final totalStudents = appState.students.length;
    final boardedCount = appState.boardedStudentCount;
    final ratio = totalStudents > 0 ? boardedCount / totalStudents : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Attendant Safety Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sos_rounded, color: AppColors.danger, size: 28),
            onPressed: () => EmergencySosModal.show(context),
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
              'Student boarding & AI verification safety telemetry',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Boarding Gauge Hero Card (Deep Obsidian Slate with Circular Percent)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppColors.primaryGlowShadow,
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 46.0,
                    lineWidth: 9.0,
                    percent: ratio.clamp(0.0, 1.0),
                    center: Text(
                      '${(ratio * 100).toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    progressColor: AppColors.success,
                    backgroundColor: Colors.white24,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BOARDING RATIO',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$boardedCount of $totalStudents Boarded',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bus: ${bus.busNumber} • ${bus.routeName}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),

            // Primary Scan Student QR CTA (Neumorphic Wrapper)
            NeumorphicCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(6),
              child: AppButton(
                text: 'SCAN STUDENT QR CODE',
                icon: Icons.qr_code_scanner_rounded,
                type: AppButtonType.secondary,
                height: 56,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                  );
                },
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 28),

            const Text(
              'Quick Verification Actions',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: NeumorphicCard(
                    onTap: () => context.go('/attendant/students'),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: AppColors.accentGlowShadow,
                          ),
                          child: const Icon(Icons.format_list_bulleted_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Student Roster',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Boarding Checklist',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NeumorphicCard(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                      );
                    },
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppColors.cyanGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.camera_front_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Face Verification',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Biometric AI Match',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 500.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }
}
