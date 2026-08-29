import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/student_card.dart';
import 'qr_scanner_screen.dart';
import 'face_verification_screen.dart';

class BoardingStudentListScreen extends StatefulWidget {
  const BoardingStudentListScreen({super.key});

  @override
  State<BoardingStudentListScreen> createState() => _BoardingStudentListScreenState();
}

class _BoardingStudentListScreenState extends State<BoardingStudentListScreen> {
  String _filter = 'All'; // All, Boarded, Pending, Exited
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final students = appState.students.where((st) {
      final matchesSearch = st.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          st.studentCode.toLowerCase().contains(_searchController.text.toLowerCase());
      if (!matchesSearch) return false;

      if (_filter == 'Boarded') return st.boardingStatus == StudentBoardingStatus.boarded;
      if (_filter == 'Pending') return st.boardingStatus == StudentBoardingStatus.notBoarded;
      if (_filter == 'Exited') return st.boardingStatus == StudentBoardingStatus.exited;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Boarding & Exit Roster'),
        actions: [
          IconButton(
            icon: const Icon(Icons.face_retouching_natural_rounded, color: AppColors.accent),
            tooltip: 'Face AI Attendance',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FaceVerificationScreen(student: students.first)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search, Filter & Dual Scanner CTAs Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Dual Scanner Action Buttons (QR Code + Face AI)
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'SCAN QR CODE',
                        icon: Icons.qr_code_scanner_rounded,
                        type: AppButtonType.primary,
                        height: 48,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        text: 'FACE AI SCAN',
                        icon: Icons.face_retouching_natural_rounded,
                        type: AppButtonType.secondary,
                        height: 48,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => FaceVerificationScreen(student: students.first)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search Field
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search student by name or ID...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Boarded', 'Pending', 'Exited'].map((f) {
                      final isSelected = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _filter = f);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Student Cards List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 120),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final st = students[index];
                return StudentCard(
                  student: st,
                  onTap: () {
                    _showStudentActionModal(context, st, appState);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.face_rounded, color: AppColors.accent, size: 22),
                        tooltip: 'Verify Face AI',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => FaceVerificationScreen(student: st)),
                          );
                        },
                      ),
                      if (st.boardingStatus == StudentBoardingStatus.boarded)
                        IconButton(
                          icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                          tooltip: 'Exit Bus Flow',
                          onPressed: () => _confirmStudentExit(context, st, appState),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showStudentActionModal(BuildContext context, Student st, AppStateService appState) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(st.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Class ${st.classId} • ${st.studentCode}', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            if (st.boardingStatus == StudentBoardingStatus.notBoarded)
              ListTile(
                leading: const Icon(Icons.face_retouching_natural_rounded, color: AppColors.accent),
                title: const Text('Verify Face AI Attendance'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FaceVerificationScreen(student: st),
                    ),
                  );
                },
              ),
            if (st.boardingStatus == StudentBoardingStatus.boarded)
              ListTile(
                leading: const Icon(Icons.school, color: AppColors.accent),
                title: const Text('Confirm Exit at School Gate'),
                onTap: () {
                  Navigator.pop(context);
                  _confirmStudentExit(context, st, appState);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _confirmStudentExit(BuildContext context, Student st, AppStateService appState) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Exit for ${st.name}?'),
        content: const Text('Has the student safely exited the bus to enter school premises?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            onPressed: () {
              appState.markStudentExited(st.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.success,
                  content: Text('✓ ${st.name} Exited Bus! Parent Notified of School Arrival.'),
                ),
              );
            },
            child: const Text('Confirm Exit'),
          ),
        ],
      ),
    );
  }
}
