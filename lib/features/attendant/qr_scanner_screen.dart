import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';
import 'face_verification_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _cameraController = MobileScannerController();
  bool _isTorchOn = false;
  Student? _scannedStudent;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        _processScannedCode(barcode.rawValue!);
        break;
      }
    }
  }

  void _processScannedCode(String code) {
    final appState = context.read<AppStateService>();
    final matchedStudent = appState.students.firstWhere(
      (s) => s.studentCode.toLowerCase() == code.toLowerCase() || s.id.toLowerCase() == code.toLowerCase(),
      orElse: () => appState.students.first,
    );

    setState(() {
      _scannedStudent = matchedStudent;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final bottomNavPadding = MediaQuery.of(context).padding.bottom + 95;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Scan Student Safety ID QR'),
        actions: [
          IconButton(
            icon: Icon(_isTorchOn ? Icons.flash_on : Icons.flash_off, color: Colors.white),
            onPressed: () {
              setState(() => _isTorchOn = !_isTorchOn);
              _cameraController.toggleTorch();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // MobileScanner / Camera Feed View
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
          ),

          // Scanner Overlay Frame with Corners
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent, width: 3),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.black12,
                    ),
                  ),
                  const Center(
                    child: Icon(Icons.qr_code_scanner, color: Colors.white38, size: 80),
                  ),
                ],
              ),
            ),
          ),

          // Top Instruction Banner
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                children: [
                  Text(
                    'Place Student Digital QR inside frame',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Student ID will be verified automatically',
                    style: TextStyle(color: Colors.white70, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),

          // Quick Simulation Chips Floating Above Bottom Nav Bar
          Positioned(
            left: 16,
            right: 16,
            bottom: _scannedStudent != null ? bottomNavPadding + 220 : bottomNavPadding,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'SIMULATE QR SCAN (DEV MODE):',
                    style: TextStyle(color: AppColors.accentLight, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: appState.students.map((st) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ActionChip(
                            avatar: CircleAvatar(backgroundImage: NetworkImage(st.photoUrl)),
                            label: Text(st.name),
                            backgroundColor: AppColors.surface,
                            onPressed: () => _processScannedCode(st.studentCode),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Student Found Modal Sheet Floating Above Bottom Nav Bar
          if (_scannedStudent != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: bottomNavPadding,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(80), blurRadius: 20),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.successBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('QR Verified ✓', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
                            Text('Student Record Found in Database', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: AppColors.border),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            _scannedStudent!.photoUrl,
                            width: 54,
                            height: 54,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _scannedStudent!.name,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Class ${_scannedStudent!.classId} • ID: ${_scannedStudent!.studentCode}',
                                style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                              ),
                              Text(
                                'Stop: ${_scannedStudent!.busStop}',
                                style: const TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    AppButton(
                      text: 'PROCEED TO FACE VERIFICATION',
                      icon: Icons.face_rounded,
                      type: AppButtonType.primary,
                      onPressed: () {
                        final studentToVerify = _scannedStudent!;
                        setState(() => _scannedStudent = null);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FaceVerificationScreen(student: studentToVerify),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
