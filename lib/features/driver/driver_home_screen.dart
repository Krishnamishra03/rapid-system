import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/emergency_sos_dialog.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final user = appState.currentUser;
    final bus = appState.busInfo;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Driver Command Console'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sos_rounded, color: AppColors.danger, size: 28),
            tooltip: 'Emergency SOS Alert',
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
              'Ready for today\'s student safety route telemetry?',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),

            // Vehicle Hero Card (Deep Obsidian Slate)
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
                            'ASSIGNED VEHICLE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bus.busNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: bus.isTripActive ? AppColors.success : Colors.white24,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text(
                              bus.isTripActive ? 'LIVE ROUTE' : 'IDLE',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    bus.routeName,
                    style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetric('Speed', '32 km/h', Colors.white),
                      _buildMetric('Students', '${appState.boardedStudentCount}/42', AppColors.accentLight),
                      _buildMetric('Next Stop', bus.nextStopName, AppColors.success),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 28),

            // Start / End Trip CTA Button (Soft Neumorphic Card Wrapper)
            NeumorphicCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(6),
              child: AppButton(
                text: bus.isTripActive ? 'END SAFETY TRIP' : 'START SAFETY TRIP',
                icon: bus.isTripActive ? Icons.stop_circle_rounded : Icons.play_circle_fill_rounded,
                type: bus.isTripActive ? AppButtonType.danger : AppButtonType.success,
                height: 58,
                onPressed: () {
                  if (bus.isTripActive) {
                    appState.endTrip();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('✓ Trip Ended! GPS broadcast stopped.')),
                    );
                  } else {
                    appState.startTrip();
                    context.go('/driver/trip');
                  }
                },
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 28),

            const Text(
              'Route Controls & Navigation',
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
                    onTap: () => context.go('/driver/trip'),
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
                          child: const Icon(Icons.navigation_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Live Map HUD',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'GPS Telemetry & Nodes',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: NeumorphicCard(
                    onTap: () => context.go('/driver/history'),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.history_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Trip History',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Past Route Logs',
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

  Widget _buildMetric(String title, String val, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title.toUpperCase(), style: const TextStyle(color: Colors.white60, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        const SizedBox(height: 2),
        Text(val, style: TextStyle(color: valColor, fontSize: 14, fontWeight: FontWeight.w900)),
      ],
    );
  }
}
