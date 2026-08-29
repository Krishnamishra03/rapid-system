import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/timeline_widget.dart';
import '../../core/widgets/emergency_sos_dialog.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final user = appState.currentUser;
    final student = appState.selectedStudent;
    final bus = appState.busInfo;
    final activeEmergency = appState.activeEmergency;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accent, width: 1),
                boxShadow: AppColors.accentGlowShadow,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: Image.asset(
                  'assets/images/app_logo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RAPID SMART',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: -0.3),
                ),
                Text(
                  'Fintech Safety Hub',
                  style: TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sos_rounded, color: AppColors.danger, size: 28),
            tooltip: 'Emergency SOS',
            onPressed: () => EmergencySosModal.show(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 600));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('⚡ Refreshed latest child safety & bus status!')),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 120.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Active Emergency SOS Banner
              if (activeEmergency != null) ...[
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: AppColors.sosGradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppColors.sosGlowShadow,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🚨 EMERGENCY SOS BROADCAST',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 0.5),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Alert triggered on ${activeEmergency.busNumber}. GPS coordinates live linked to School Admin.',
                              style: const TextStyle(color: Colors.white70, fontSize: 12, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().shake(),
              ],

              // Greeting Header with Soft Neumorphic Ring
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
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
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        "Live child safety & bus telemetry overview",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.accentGlowShadow,
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(user.avatarUrl ?? 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150'),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),
              const SizedBox(height: 22),

              // Child Card Hero (Soft Neumorphism & Fintech Blue Gradient)
              NeumorphicCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(17),
                            child: Image.network(
                              student.photoUrl,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textPrimary,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                'Class ${student.classId} (${student.section}) • ${student.studentCode}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              StatusBadge(
                                label: bus.isTripActive ? 'Safe & On Route 🟢' : 'In School Campus',
                                type: BadgeType.onRoute,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 18),

                    // Vehicle & Live ETA Row (Glassmorphic Inset Pills)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceSubtle,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('BUS VEHICLE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.textMuted)),
                                    Text(student.busId, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.infoBg,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.accent.withAlpha(60)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.accentGradient,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.timer_rounded, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('ESTIMATED ETA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.accent)),
                                    Text('${bus.etaMinutes} min', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.accent)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    AppButton(
                      text: 'TRACK LIVE BUS MAP',
                      icon: Icons.map_rounded,
                      type: AppButtonType.secondary,
                      onPressed: () {
                        context.go('/parent/bus');
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 28),

              // Today's Safety Timeline Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Telemetry Log",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.history, size: 16, color: AppColors.accent),
                    label: const Text(
                      'Full Logs',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.accent),
                    ),
                    onPressed: () {
                      context.go('/parent/attendance');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              NeumorphicCard(
                borderRadius: 28,
                padding: const EdgeInsets.all(22),
                child: TimelineWidget(
                  steps: [
                    const TimelineStep(
                      title: 'Bus Started Route 5',
                      subtitle: 'Central Depot Departure • Driver: Rajesh Kumar',
                      time: '07:20 AM',
                      isCompleted: true,
                      icon: Icons.directions_bus_rounded,
                    ),
                    const TimelineStep(
                      title: 'Bus Arrived Near Stop',
                      subtitle: 'Civil Lines Stop 3 Node',
                      time: '07:38 AM',
                      isCompleted: true,
                      icon: Icons.location_on_rounded,
                    ),
                    TimelineStep(
                      title: '${student.name} Boarded Bus',
                      subtitle: student.qrVerified && student.faceVerified
                          ? 'QR Code Scan + Face Verification ✓'
                          : 'Verification Pending',
                      time: student.boardedTime ?? '07:42 AM',
                      isCompleted: student.boardingStatus == StudentBoardingStatus.boarded || student.boardingStatus == StudentBoardingStatus.exited,
                      isCurrent: student.boardingStatus == StudentBoardingStatus.boarded,
                      icon: Icons.qr_code_scanner_rounded,
                    ),
                    TimelineStep(
                      title: 'Reached School Campus',
                      subtitle: 'St. Xavier High School Gate 2 Arrival',
                      time: '08:25 AM',
                      isCompleted: student.boardingStatus == StudentBoardingStatus.exited,
                      icon: Icons.school_rounded,
                    ),
                    const TimelineStep(
                      title: 'Classroom Attendance Logged',
                      subtitle: 'Class 8-A Roster • Verified by Educator Priya',
                      time: '09:00 AM',
                      isCompleted: false,
                      icon: Icons.fact_check_rounded,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
