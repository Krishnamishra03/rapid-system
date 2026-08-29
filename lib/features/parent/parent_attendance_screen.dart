import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/neumorphic_glass_widgets.dart';

class ParentAttendanceScreen extends StatefulWidget {
  const ParentAttendanceScreen({super.key});

  @override
  State<ParentAttendanceScreen> createState() => _ParentAttendanceScreenState();
}

class _ParentAttendanceScreenState extends State<ParentAttendanceScreen> {
  int _selectedPeriodIndex = 2; // Monthly default

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final student = appState.selectedStudent;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Attendance Telemetry'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0, bottom: 120.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Card Header (Neumorphic Soft Container)
            NeumorphicCard(
              borderRadius: 20,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      student.photoUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        'Class ${student.classId} • ${student.studentCode}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
            const SizedBox(height: 20),

            // Overview Card with Fintech Circular Progress
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppColors.primaryGlowShadow,
              ),
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 48.0,
                    lineWidth: 10.0,
                    percent: student.attendancePercentage / 100,
                    center: Text(
                      '${student.attendancePercentage.toInt()}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 19.0,
                        color: Colors.white,
                      ),
                    ),
                    progressColor: AppColors.success,
                    backgroundColor: Colors.white24,
                    circularStrokeCap: CircularStrokeCap.round,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Overall Attendance Score',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatItem('Present', '22', AppColors.success),
                            _buildStatItem('Absent', '2', AppColors.danger),
                            _buildStatItem('Late', '1', AppColors.warning),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 24),

            // Time Period Selector (Neumorphic Soft Segmented Control)
            NeumorphicCard(
              borderRadius: 20,
              padding: const EdgeInsets.all(4),
              child: Row(
                children: ['Daily', 'Weekly', 'Monthly'].asMap().entries.map((entry) {
                  final idx = entry.key;
                  final label = entry.value;
                  final isSelected = _selectedPeriodIndex == idx;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedPeriodIndex = idx),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isSelected ? AppColors.accentGradient : null,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isSelected ? AppColors.accentGlowShadow : null,
                        ),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: isSelected ? Colors.white : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Monthly Attendance Bar Chart (Neumorphic Card)
            const Text(
              'Attendance Score History',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            NeumorphicCard(
              borderRadius: 28,
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 180,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 25,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (val, meta) {
                            const months = ['Apr', 'May', 'Jun', 'Jul', 'Aug'];
                            if (val.toInt() < months.length) {
                              return Text(
                                months[val.toInt()],
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barGroups: [
                      _makeBarGroup(0, 22),
                      _makeBarGroup(1, 24),
                      _makeBarGroup(2, 21),
                      _makeBarGroup(3, 23),
                      _makeBarGroup(4, 22),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
            const SizedBox(height: 28),

            // Attendance Logs History
            const Text(
              'Recent Activity Logs',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),

            _buildLogCard(
              date: 'Today, 20 Aug',
              time: '07:42 AM',
              title: 'Bus Boarding Verified',
              subtitle: 'QR Scan + Face Verification at Civil Lines Stop 3',
              type: BadgeType.present,
            ),
            _buildLogCard(
              date: 'Yesterday, 19 Aug',
              time: '08:25 AM',
              title: 'School Exit Confirmed',
              subtitle: 'Safely entered St. Xavier School campus',
              type: BadgeType.exited,
            ),
            _buildLogCard(
              date: '18 Aug 2026',
              time: '09:00 AM',
              title: 'Class 8-A Attendance',
              subtitle: 'Marked Present by Teacher Priya Verma',
              type: BadgeType.present,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: color),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: AppColors.accentGradient,
          width: 18,
          borderRadius: BorderRadius.circular(8),
        ),
      ],
    );
  }

  Widget _buildLogCard({
    required String date,
    required String time,
    required String title,
    required String subtitle,
    required BadgeType type,
  }) {
    return NeumorphicCard(
      margin: const EdgeInsets.only(bottom: 12),
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.success.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text('$date • $time', style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          StatusBadge(label: 'Verified', type: type, showDot: false),
        ],
      ),
    );
  }
}
