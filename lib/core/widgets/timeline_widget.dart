import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class TimelineStep {
  final String title;
  final String subtitle;
  final String time;
  final bool isCompleted;
  final bool isCurrent;
  final IconData icon;

  const TimelineStep({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.isCompleted,
    this.isCurrent = false,
    required this.icon,
  });
}

class TimelineWidget extends StatelessWidget {
  final List<TimelineStep> steps;

  const TimelineWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        Color circleBg = step.isCompleted
            ? AppColors.success
            : (step.isCurrent ? AppColors.accent : AppColors.surfaceSubtle);
        Color iconColor = (step.isCompleted || step.isCurrent) ? Colors.white : AppColors.textMuted;
        Color lineColor = step.isCompleted ? AppColors.success : AppColors.border;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time
              SizedBox(
                width: 65,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    step.time,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: step.isCompleted || step.isCurrent
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              // Line & Icon
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: circleBg,
                      shape: BoxShape.circle,
                      boxShadow: step.isCurrent
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withAlpha(80),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(step.icon, size: 16, color: iconColor),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        color: lineColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 14),
              // Step Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: step.isCompleted || step.isCurrent
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: step.isCompleted ? AppColors.textSecondary : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
