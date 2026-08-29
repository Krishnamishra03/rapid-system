import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _startAutoNavigation();
  }

  void _startAutoNavigation() {
    _navigationTimer = Timer(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      context.go('/login');
    });
  }

  @override
  void dispose() {
    _glowController.dispose();
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Exact match with LoginScreen (#F0F4F8)
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Background Ambient Glow Circles (Identical to LoginScreen)
          AnimatedBuilder(
            animation: _glowController,
            builder: (context, child) {
              final val = _glowController.value;
              return Stack(
                children: [
                  Positioned(
                    top: -50 + (val * 20),
                    right: -50,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent.withAlpha(35 + (val * 20).toInt()),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 30 - (val * 20),
                    left: -70,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cyanNeon.withAlpha(30 + (val * 20).toInt()),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Floating Particles
          Positioned(
            top: 140,
            left: 45,
            child: _buildOrbNode(24, AppColors.accent),
          ),
          Positioned(
            bottom: 180,
            right: 50,
            child: _buildOrbNode(30, AppColors.cyanNeon),
          ),

          // MAIN HERO CONTENT - 100% MATHEMATICAL & OPTICAL CENTER ALIGNMENT
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Official Logo Emblem Badge inside Neumorphic Container (Matches Login Screen)
                    NeumorphicCard(
                      borderRadius: 44,
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(color: AppColors.accent, width: 2),
                          boxShadow: AppColors.accentGlowShadow,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'assets/images/app_logo.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .scale(duration: 900.ms, curve: Curves.easeOutBack)
                        .fadeIn(duration: 600.ms)
                        .shimmer(delay: 1000.ms, duration: 1500.ms),
                    const SizedBox(height: 32),

                    // App Main Title & Subtitle (Matches Login Screen Typography)
                    const Text(
                      'RAPID SMART',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.5,
                      ),
                    ).animate().slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 200.ms).fadeIn(),
                    const SizedBox(height: 4),

                    const Text(
                      'Attendance & Student Safety Hub',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                        letterSpacing: 0.5,
                      ),
                    ).animate().slideY(begin: 0.4, end: 0, duration: 500.ms, delay: 350.ms).fadeIn(),
                    const SizedBox(height: 20),

                    // Soft Neumorphic Tagline Pill
                    NeumorphicCard(
                      borderRadius: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.6, 1.6),
                                duration: 700.ms,
                              ),
                          const SizedBox(width: 10),
                          const Text(
                            'Every Student • Every Journey • Every Day',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ).animate().scale(delay: 500.ms, duration: 450.ms, curve: Curves.easeOutBack).fadeIn(),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Neumorphic Encrypted Security Badge
          Positioned(
            bottom: 40,
            child: SafeArea(
              child: NeumorphicCard(
                borderRadius: 20,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_user_rounded,
                      color: AppColors.success,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      '256-Bit Encrypted Security Telemetry',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrbNode(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withAlpha(40),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
          begin: const Offset(1, 1),
          end: const Offset(1.3, 1.3),
          duration: 2200.ms,
        );
  }
}
