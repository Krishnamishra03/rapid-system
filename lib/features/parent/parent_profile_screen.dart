import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/digital_id_card.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final user = appState.currentUser;
    final student = appState.selectedStudent;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Student Safety Pass & Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
            onPressed: () {
              appState.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Digital Student ID Card Pass
            DigitalStudentIdCard(student: student).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
            const SizedBox(height: 28),

            // Profile Details Section (Soft Neumorphic Cards)
            const Text(
              'Account & Parent Details',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            NeumorphicCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _buildProfileTile(Icons.person_outline_rounded, 'Parent Name', user.name),
                  const Divider(color: AppColors.border, height: 20),
                  _buildProfileTile(Icons.phone_iphone_rounded, 'Emergency Phone', user.phone),
                  const Divider(color: AppColors.border, height: 20),
                  _buildProfileTile(Icons.email_outlined, 'Email Address', user.email),
                  const Divider(color: AppColors.border, height: 20),
                  _buildProfileTile(Icons.route_rounded, 'Assigned Route', student.routeName),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 28),

            const Text(
              'Safety Preferences',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            NeumorphicCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _buildSwitchTile('Live Bus Geofence Alerts', true),
                  const Divider(color: AppColors.border, height: 20),
                  _buildSwitchTile('Boarding / Exit Instant SMS', true),
                  const Divider(color: AppColors.border, height: 20),
                  _buildSwitchTile('Biometric AI Verification', true),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.accent.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.accent, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(String title, bool val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        Switch(
          value: val,
          activeTrackColor: AppColors.accent,
          onChanged: (v) {},
        ),
      ],
    );
  }
}
