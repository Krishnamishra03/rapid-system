import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/student_model.dart';
import 'status_badge.dart';

class StudentCard extends StatelessWidget {
  final Student student;
  final VoidCallback? onTap;
  final Widget? trailing;

  const StudentCard({
    super.key,
    required this.student,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    BadgeType badgeType;
    String badgeLabel;

    switch (student.boardingStatus) {
      case StudentBoardingStatus.boarded:
        badgeType = BadgeType.boarded;
        badgeLabel = 'Boarded (${student.boardedTime ?? '7:42 AM'})';
        break;
      case StudentBoardingStatus.exited:
        badgeType = BadgeType.exited;
        badgeLabel = 'Exited at School';
        break;
      case StudentBoardingStatus.notBoarded:
        badgeType = BadgeType.pending;
        badgeLabel = 'Pending Boarding';
        break;
      case StudentBoardingStatus.absent:
        badgeType = BadgeType.absent;
        badgeLabel = 'Absent';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppColors.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Student Avatar Photo with Ring Accent
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      student.photoUrl,
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 58,
                        height: 58,
                        color: AppColors.surfaceSubtle,
                        child: const Icon(Icons.person, color: AppColors.textMuted, size: 28),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Class ${student.classId} (${student.section}) • ${student.studentCode}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            StatusBadge(label: badgeLabel, type: badgeType),
                            if (student.qrVerified && student.faceVerified) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.successBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.verified, size: 14, color: AppColors.success),
                                    SizedBox(width: 4),
                                    Text(
                                      'AI Verified',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
