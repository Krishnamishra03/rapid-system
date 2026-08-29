import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/notification_model.dart';
import '../../core/services/app_state_service.dart';
import '../../core/widgets/empty_states.dart';

class ParentNotificationsScreen extends StatefulWidget {
  const ParentNotificationsScreen({super.key});

  @override
  State<ParentNotificationsScreen> createState() => _ParentNotificationsScreenState();
}

class _ParentNotificationsScreenState extends State<ParentNotificationsScreen> {
  NotificationCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();
    final notifications = appState.notifications.where((n) {
      if (_selectedCategory == null) return true;
      return n.category == _selectedCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications Center'),
        actions: [
          if (appState.unreadNotificationCount > 0)
            TextButton.icon(
              icon: const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Mark all read'),
              onPressed: () => appState.markAllNotificationsAsRead(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _buildCategoryFilterChip(label: 'All', category: null),
                _buildCategoryFilterChip(label: '🚌 Bus', category: NotificationCategory.bus),
                _buildCategoryFilterChip(label: '✓ Attendance', category: NotificationCategory.attendance),
                _buildCategoryFilterChip(label: '🏫 School', category: NotificationCategory.school),
                _buildCategoryFilterChip(label: '🚨 Emergency', category: NotificationCategory.emergency),
              ],
            ),
          ),

          Expanded(
            child: notifications.isEmpty
                ? const EmptyStateWidget(
                    title: 'No Notifications Yet',
                    message: 'Safety updates, bus status, and attendance alerts will appear here.',
                    icon: Icons.notifications_off_outlined,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final n = notifications[index];
                      return _buildNotificationCard(context, n, appState);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilterChip({required String label, required NotificationCategory? category}) {
    final isSelected = _selectedCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        onSelected: (selected) {
          setState(() {
            _selectedCategory = selected ? category : null;
          });
        },
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, AppNotification n, AppStateService appState) {
    Color categoryBg;
    IconData categoryIcon;

    switch (n.category) {
      case NotificationCategory.bus:
        categoryBg = AppColors.accent;
        categoryIcon = Icons.directions_bus_rounded;
        break;
      case NotificationCategory.attendance:
        categoryBg = AppColors.success;
        categoryIcon = Icons.check_circle_rounded;
        break;
      case NotificationCategory.school:
        categoryBg = AppColors.primary;
        categoryIcon = Icons.school_rounded;
        break;
      case NotificationCategory.emergency:
        categoryBg = AppColors.danger;
        categoryIcon = Icons.warning_rounded;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: n.isRead ? AppColors.surface : Colors.white,
      child: InkWell(
        onTap: () => appState.markNotificationAsRead(n.id),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: categoryBg.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(categoryIcon, color: categoryBg, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            n.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: n.isRead ? FontWeight.bold : FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (!n.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      n.message,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatTimestamp(n.timestamp),
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} minutes ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    }
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
