import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/student_model.dart';
import '../../core/widgets/app_buttons.dart';
import '../../core/widgets/student_card.dart';
import '../attendant/qr_scanner_screen.dart';
import '../attendant/face_verification_screen.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  const TeacherAttendanceScreen({super.key});

  @override
  State<TeacherAttendanceScreen> createState() => _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  String _selectedClass = '8-A';
  String _filter = 'All'; // All, Present, Absent
  final _searchController = TextEditingController();

  // Class-wise student dataset for demo testing
  final Map<String, List<Student>> _classStudents = {
    '8-A': [
      const Student(
        id: 'stu-001',
        name: 'Rahul Sharma',
        photoUrl: 'https://images.unsplash.com/photo-1544717305-2782549b5136?w=150',
        classId: '8-A',
        section: 'A',
        studentCode: 'STU-8042',
        parentName: 'Amit Sharma',
        parentPhone: '+91 98765 43210',
        busId: 'BUS-001',
        routeName: 'Route 5',
        busStop: 'Bhopal Nagar',
        attendancePercentage: 95.0,
      ),
      const Student(
        id: 'stu-002',
        name: 'Aman Verma',
        photoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
        classId: '8-A',
        section: 'A',
        studentCode: 'STU-8043',
        parentName: 'Suresh Verma',
        parentPhone: '+91 98123 00001',
        busId: 'BUS-001',
        routeName: 'Route 5',
        busStop: 'MP Nagar',
        attendancePercentage: 92.5,
      ),
      const Student(
        id: 'stu-003',
        name: 'Priya Singh',
        photoUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        classId: '8-A',
        section: 'A',
        studentCode: 'STU-8044',
        parentName: 'Vikram Singh',
        parentPhone: '+91 98123 00002',
        busId: 'BUS-001',
        routeName: 'Route 5',
        busStop: 'Civil Lines',
        attendancePercentage: 98.0,
      ),
      const Student(
        id: 'stu-004',
        name: 'Ankit Jain',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        classId: '8-A',
        section: 'A',
        studentCode: 'STU-8045',
        parentName: 'Rakesh Jain',
        parentPhone: '+91 98123 00003',
        busId: 'BUS-001',
        routeName: 'Route 5',
        busStop: 'Bhopal Nagar',
        attendancePercentage: 88.0,
      ),
      const Student(
        id: 'stu-005',
        name: 'Rohit Sharma',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        classId: '8-A',
        section: 'A',
        studentCode: 'STU-8046',
        parentName: 'Sunil Sharma',
        parentPhone: '+91 98123 00004',
        busId: 'BUS-001',
        routeName: 'Route 5',
        busStop: 'Bhopal Nagar',
        attendancePercentage: 91.0,
      ),
      const Student(
        id: 'stu-006',
        name: 'Neha Gupta',
        photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        classId: '8-A',
        section: 'A',
        studentCode: 'STU-8047',
        parentName: 'Deepak Gupta',
        parentPhone: '+91 98123 00005',
        busId: 'BUS-001',
        routeName: 'Route 5',
        busStop: 'Arera Colony',
        attendancePercentage: 96.0,
      ),
    ],
    '8-B': [
      const Student(
        id: 'stu-8b-01',
        name: 'Kabir Mehta',
        photoUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
        classId: '8-B',
        section: 'B',
        studentCode: 'STU-8B01',
        parentName: 'Sanjay Mehta',
        parentPhone: '+91 98765 11111',
        busId: 'BUS-002',
        routeName: 'Route 2',
        busStop: 'Kolar Road',
        attendancePercentage: 94.0,
      ),
      const Student(
        id: 'stu-8b-02',
        name: 'Ananya Roy',
        photoUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
        classId: '8-B',
        section: 'B',
        studentCode: 'STU-8B02',
        parentName: 'Subhash Roy',
        parentPhone: '+91 98765 22222',
        busId: 'BUS-002',
        routeName: 'Route 2',
        busStop: 'Shahpura',
        attendancePercentage: 97.0,
      ),
      const Student(
        id: 'stu-8b-03',
        name: 'Dev Patel',
        photoUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        classId: '8-B',
        section: 'B',
        studentCode: 'STU-8B03',
        parentName: 'Nitin Patel',
        parentPhone: '+91 98765 33333',
        busId: 'BUS-002',
        routeName: 'Route 2',
        busStop: 'Habibganj',
        attendancePercentage: 91.0,
      ),
    ],
    '9-A': [
      const Student(
        id: 'stu-9a-01',
        name: 'Aarav Kulkarni',
        photoUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
        classId: '9-A',
        section: 'A',
        studentCode: 'STU-9A01',
        parentName: 'Anil Kulkarni',
        parentPhone: '+91 98765 44444',
        busId: 'BUS-003',
        routeName: 'Route 3',
        busStop: 'Indrapuri',
        attendancePercentage: 96.5,
      ),
      const Student(
        id: 'stu-9a-02',
        name: 'Diya Joshi',
        photoUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=150',
        classId: '9-A',
        section: 'A',
        studentCode: 'STU-9A02',
        parentName: 'Vijay Joshi',
        parentPhone: '+91 98765 55555',
        busId: 'BUS-003',
        routeName: 'Route 3',
        busStop: 'Govindpura',
        attendancePercentage: 99.0,
      ),
    ],
  };

  final Map<String, bool> _presentStatus = {
    'stu-001': true,
    'stu-002': true,
    'stu-003': true,
    'stu-004': false,
    'stu-005': true,
    'stu-006': false,
    'stu-8b-01': true,
    'stu-8b-02': true,
    'stu-8b-03': true,
    'stu-9a-01': true,
    'stu-9a-02': true,
  };

  @override
  Widget build(BuildContext context) {
    final classList = _classStudents[_selectedClass] ?? _classStudents['8-A']!;

    final filteredStudents = classList.where((st) {
      final matchesSearch = st.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
          st.studentCode.toLowerCase().contains(_searchController.text.toLowerCase());
      if (!matchesSearch) return false;

      final isPresent = _presentStatus[st.id] ?? true;
      if (_filter == 'Present') return isPresent;
      if (_filter == 'Absent') return !isPresent;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Take Classroom Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh Roster',
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('⚡ Classroom Attendance Roster Refreshed!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.face_retouching_natural_rounded, color: AppColors.accent),
            tooltip: 'Face AI Attendance',
            onPressed: () => _openFaceScan(context, classList.first),
          ),
        ],
      ),
      body: Column(
        children: [
          // Class Selection, Search & Dual Scanner CTAs
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Class Selector & Save CTA
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedClass,
                            isExpanded: true,
                            items: ['8-A', '8-B', '9-A'].map((c) {
                              final count = _classStudents[c]?.length ?? 0;
                              return DropdownMenuItem(
                                value: c,
                                child: Text(
                                  'Class $c ($count Students)',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedClass = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.cloud_upload_rounded, size: 18),
                      label: const Text('Save'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppColors.success,
                            content: Text('✓ Class $_selectedClass Attendance Saved & Parents Notified!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Dual Scanner Actions (QR Code + Face AI)
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'SCAN QR CODE',
                        icon: Icons.qr_code_scanner_rounded,
                        type: AppButtonType.primary,
                        height: 48,
                        onPressed: () => _openQrScanner(context),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        text: 'FACE AI ATTENDANCE',
                        icon: Icons.face_retouching_natural_rounded,
                        type: AppButtonType.secondary,
                        height: 48,
                        onPressed: () => _openFaceScan(context, classList.first),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Search Box
                TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search student name or roll number...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter & Quick Bulk Actions Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: ['All', 'Present', 'Absent'].map((f) {
                          final isSelected = _filter == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: ChoiceChip(
                              label: Text(f),
                              selected: isSelected,
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                              onSelected: (val) {
                                if (val) setState(() => _filter = f);
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          for (var st in classList) {
                            _presentStatus[st.id] = true;
                          }
                        });
                      },
                      child: const Text('Mark All Present', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Students Roster List
          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(
                    child: Text(
                      'No students found for selected criteria.',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 120),
                    itemCount: filteredStudents.length,
                    itemBuilder: (context, index) {
                      final st = filteredStudents[index];
                      final isPresent = _presentStatus[st.id] ?? true;

                      return StudentCard(
                        student: st,
                        onTap: () => _openFaceScan(context, st),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.face_rounded, color: AppColors.accent, size: 22),
                              tooltip: 'Verify Face AI',
                              onPressed: () => _openFaceScan(context, st),
                            ),
                            Text(
                              isPresent ? 'Present' : 'Absent',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isPresent ? AppColors.success : AppColors.danger,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Switch(
                              value: isPresent,
                              activeTrackColor: AppColors.success,
                              onChanged: (val) {
                                setState(() {
                                  _presentStatus[st.id] = val;
                                });
                              },
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

  void _openQrScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QrScannerScreen()),
    );
  }

  void _openFaceScan(BuildContext context, Student student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FaceVerificationScreen(student: student)),
    );
  }
}
