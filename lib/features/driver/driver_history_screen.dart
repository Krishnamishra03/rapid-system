import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/status_badge.dart';

class DriverHistoryScreen extends StatelessWidget {
  const DriverHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = [
      {
        'route': 'Route 5 - Morning Pick Up',
        'date': '20 Aug 2026',
        'startTime': '07:20 AM',
        'endTime': '08:30 AM',
        'students': 42,
        'busNumber': 'BUS-001',
      },
      {
        'route': 'Route 5 - Afternoon Drop',
        'date': '19 Aug 2026',
        'startTime': '02:15 PM',
        'endTime': '03:40 PM',
        'students': 42,
        'busNumber': 'BUS-001',
      },
      {
        'route': 'Route 5 - Morning Pick Up',
        'date': '19 Aug 2026',
        'startTime': '07:20 AM',
        'endTime': '08:28 AM',
        'students': 41,
        'busNumber': 'BUS-001',
      },
      {
        'route': 'Route 5 - Afternoon Drop',
        'date': '18 Aug 2026',
        'startTime': '02:15 PM',
        'endTime': '03:35 PM',
        'students': 42,
        'busNumber': 'BUS-001',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trip History Logs'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
        itemCount: history.length,
        itemBuilder: (context, index) {
          final item = history[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['route'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const StatusBadge(label: 'Completed ✓', type: BadgeType.present, showDot: false),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${item['date']} • Vehicle ${item['busNumber']}',
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
                const SizedBox(height: 14),
                const Divider(color: AppColors.border, height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMeta('Started', item['startTime'] as String),
                    _buildMeta('Ended', item['endTime'] as String),
                    _buildMeta('Students Safely Delivered', '${item['students']}'),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMeta(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
