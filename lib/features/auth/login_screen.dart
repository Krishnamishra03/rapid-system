import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/user_model.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'amit.sharma@example.com');
  final _passwordController = TextEditingController(text: 'password123');

  bool _rememberMe = true;
  bool _isLoading = false;
  bool _useOtp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    final appState = context.read<AppStateService>();
    appState.login(_emailController.text, _passwordController.text);

    setState(() => _isLoading = false);
    context.go(appState.currentUser.role.defaultRoute);
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated Background Ambient Glow Circles
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accent.withAlpha(35),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.2, 1.2),
                  duration: 3000.ms,
                ),
          ),
          Positioned(
            bottom: 40,
            left: -80,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.cyanNeon.withAlpha(30),
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.25, 1.25),
                  duration: 4000.ms,
                ),
          ),

          // Main Form Body
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // App Brand Header Card (Official Logo with Animated Glow Ring)
                    NeumorphicCard(
                      borderRadius: 28,
                      padding: const EdgeInsets.all(18),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.accent, width: 2),
                              boxShadow: AppColors.accentGlowShadow,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/app_logo.jpg',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RAPID SMART',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textPrimary,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Attendance & Student Safety',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.accent,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.verified_user_rounded, size: 12, color: AppColors.success),
                                    SizedBox(width: 4),
                                    Text(
                                      '256-Bit Encrypted Portal',
                                      style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2, end: 0),
                    const SizedBox(height: 28),

                    // Welcome Text Banner
                    const Text(
                      'Welcome Back 👋',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ).animate().fadeIn(delay: 150.ms).slideX(begin: -0.1, end: 0),
                    const SizedBox(height: 4),
                    const Text(
                      'Sign in to track live student journey & safety telemetry.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ).animate().fadeIn(delay: 250.ms),
                    const SizedBox(height: 24),

                    // Animated Mode Toggle (Password Login vs OTP Verification)
                    NeumorphicCard(
                      borderRadius: 20,
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _useOtp = false),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: !_useOtp ? AppColors.accentGradient : null,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: !_useOtp ? AppColors.accentGlowShadow : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.lock_person_rounded,
                                      size: 18,
                                      color: !_useOtp ? Colors.white : AppColors.textMuted,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Password Login',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: !_useOtp ? Colors.white : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _useOtp = true),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: _useOtp ? AppColors.cyanGradient : null,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: _useOtp ? AppColors.accentGlowShadow : null,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.phone_iphone_rounded,
                                      size: 18,
                                      color: _useOtp ? Colors.white : AppColors.textMuted,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'OTP Verification',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: _useOtp ? Colors.white : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 24),

                    // Inputs Section inside Neumorphic Container
                    NeumorphicCard(
                      borderRadius: 28,
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            label: _useOtp ? 'Registered Mobile Number' : 'Email Address / Mobile ID',
                            hint: _useOtp ? '+91 98765 43210' : 'amit.sharma@example.com',
                            controller: _emailController,
                            prefixIcon: _useOtp ? Icons.phone_android_rounded : Icons.mark_email_read_rounded,
                            keyboardType: _useOtp ? TextInputType.phone : TextInputType.emailAddress,
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter your registered credentials';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),

                          if (!_useOtp) ...[
                            AppTextField(
                              label: 'Security Password',
                              hint: '••••••••',
                              controller: _passwordController,
                              prefixIcon: Icons.lock_outline_rounded,
                              obscureText: true,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: Checkbox(
                                        value: _rememberMe,
                                        activeColor: AppColors.accent,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        onChanged: (v) => setState(() => _rememberMe = v ?? true),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Remember Me',
                                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else ...[
                            AppButton(
                              text: 'SEND OTP CODE VIA SMS',
                              icon: Icons.send_rounded,
                              type: AppButtonType.secondary,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: AppColors.success,
                                    content: Text('✓ OTP code 4829 sent to registered mobile!'),
                                  ),
                                );
                              },
                            ),
                          ],
                          const SizedBox(height: 22),

                          AppButton(
                            text: 'SIGN IN TO PORTAL',
                            icon: Icons.arrow_forward_rounded,
                            isLoading: _isLoading,
                            onPressed: _handleLogin,
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.1, end: 0),
                    const SizedBox(height: 28),

                    // Role Switcher Cards Grid
                    const Text(
                      'Select User Role Demo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tap a role to switch portal views automatically:',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 14),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: UserRole.values.map((role) {
                        final isSelected = appState.currentUser.role == role;
                        final icon = role == UserRole.parent
                            ? Icons.family_restroom_rounded
                            : (role == UserRole.driver
                                ? Icons.directions_bus_rounded
                                : (role == UserRole.attendant ? Icons.qr_code_scanner_rounded : Icons.school_rounded));

                        return GestureDetector(
                          onTap: () {
                            appState.switchRole(role);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: AppColors.primary,
                                duration: const Duration(milliseconds: 800),
                                content: Text('Switched to ${role.displayName} Portal!'),
                              ),
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.background,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected ? AppColors.accent : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected ? AppColors.primaryGlowShadow : AppColors.neumorphicSoft,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isSelected ? AppColors.accent : AppColors.accent.withAlpha(20),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(icon, color: isSelected ? Colors.white : AppColors.accent, size: 20),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        role.displayName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: isSelected ? Colors.white : AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        isSelected ? 'Active ✓' : 'Tap to switch',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected ? AppColors.accentLight : AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ).animate().fadeIn(delay: 550.ms).slideY(begin: 0.1, end: 0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
