import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';

class FaceVerificationScreen extends StatefulWidget {
  final Student student;

  const FaceVerificationScreen({super.key, required this.student});

  @override
  State<FaceVerificationScreen> createState() => _FaceVerificationScreenState();
}

class _FaceVerificationScreenState extends State<FaceVerificationScreen> {
  bool _isVerifying = true;
  bool _isSuccess = false;
  bool _hasFailed = false;

  @override
  void initState() {
    super.initState();
    _startFaceScan();
  }

  void _startFaceScan() async {
    setState(() {
      _isVerifying = true;
      _isSuccess = false;
      _hasFailed = false;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Simulate match success
    setState(() {
      _isVerifying = false;
      _isSuccess = true;
    });

    // Confirm boarding attendance in state
    context.read<AppStateService>().markStudentBoarded(
          widget.student.id,
          qrVerified: true,
          faceVerified: true,
        );
  }

  void _triggerFailureSim() {
    setState(() {
      _isVerifying = false;
      _isSuccess = false;
      _hasFailed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Face Verification AI'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Text(
                'Verify Student Identity',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Position face inside oval outline for ${widget.student.name}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
                ),
              ),
              const Spacer(),

              // Face Scanner Camera Preview Simulation Container
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Simulated Camera Box / Student Photo Overlay
                    Container(
                      width: 240,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(150), // Oval
                        border: Border.all(
                          color: _isVerifying
                              ? AppColors.accent
                              : (_isSuccess ? AppColors.success : AppColors.danger),
                          width: 4,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_isSuccess ? AppColors.success : AppColors.accent).withAlpha(100),
                            blurRadius: 30,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150),
                        child: Image.network(
                          widget.student.photoUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.face,
                            size: 100,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                    ),

                    // Animated Scanning Beam
                    if (_isVerifying)
                      Container(
                        width: 240,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 4,
                            width: 220,
                            color: AppColors.accentLight,
                          ).animate(onPlay: (c) => c.repeat(reverse: true)).slideY(
                                begin: 0.1,
                                end: 1.8,
                                duration: 1200.ms,
                              ),
                        ),
                      ),

                    // Success Checkmark Badge
                    if (_isSuccess)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),

                    // Failure Alert Badge
                    if (_hasFailed)
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: AppColors.danger,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 64,
                        ),
                      ).animate().shake(),
                  ],
                ),
              ),

              const Spacer(),

              // Status Details Card
              if (_isVerifying) ...[
                const Column(
                  children: [
                    SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Analyzing Facial Features...',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      'Matching against enrolled student safety profile',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ] else if (_isSuccess) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        '✓ Identity Verified',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'QR Verified • Face Verified ✓',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Boarding Attendance Confirmed',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      AppButton(
                        text: 'DONE & RETURN TO BOARDING LIST',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ).animate().slideY(begin: 0.3, end: 0),
                ),
              ] else if (_hasFailed) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Face Verification Failed',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.danger,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Facial match threshold not met. Please align face clearly.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Back'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                              onPressed: _startFaceScan,
                              child: const Text('Try Again'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 16),
              // Dev Switcher link for testing failure state
              if (_isVerifying)
                TextButton(
                  onPressed: _triggerFailureSim,
                  child: const Text(
                    'Simulate Face Match Failure (Dev Mode)',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
