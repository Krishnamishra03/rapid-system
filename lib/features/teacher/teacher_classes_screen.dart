import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../attendant/qr_scanner_screen.dart';

class TeacherClassesScreen extends StatelessWidget {
  const TeacherClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      {'name': 'Class 8-A', 'students': 40, 'present': 36, 'absent': 4, 'room': 'Room 204', 'isPrimary': true},
      {'name': 'Class 8-B', 'students': 38, 'present': 34, 'absent': 4, 'room': 'Room 205', 'isPrimary': false},
      {'name': 'Class 9-A', 'students': 42, 'present': 40, 'absent': 2, 'room': 'Room 301', 'isPrimary': false},
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Assigned Classes & Roster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: AppColors.accent),
            tooltip: 'Open QR Scanner',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QrScannerScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final cls = classes[index];
          final isPrimary = cls['isPrimary'] as bool;
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isPrimary ? AppColors.accent : AppColors.border, width: isPrimary ? 2 : 1),
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isPrimary ? AppColors.primary : AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.groups_rounded, color: isPrimary ? Colors.white : AppColors.textPrimary, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cls['name'] as String,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${cls['students']} Enrolled • ${cls['room']}',
                            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    if (isPrimary)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withAlpha(20),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Primary Class',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.accent),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: AppColors.border),
                const SizedBox(height: 12),

                // Present vs Absent ratio pills
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Present Today: ${cls['present']} / ${cls['students']}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.success),
                    ),
                    Text(
                      'Absent: ${cls['absent']}',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.danger),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Actions Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.qr_code_scanner, size: 18),
                        label: const Text('Scan QR'),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isPrimary ? AppColors.accent : AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.fact_check, size: 18),
                        label: const Text('Take Attendance'),
                        onPressed: () {
                          context.go('/teacher/attendance');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
