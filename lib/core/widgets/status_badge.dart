import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum BadgeType {
  onRoute,
  boarded,
  exited,
  present,
  absent,
  warning,
  emergency,
  pending,
}

class StatusBadge extends StatefulWidget {
  final String label;
  final BadgeType type;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.label,
    required this.type,
    this.showDot = true,
  });

  @override
  State<StatusBadge> createState() => _StatusBadgeState();
}

class _StatusBadgeState extends State<StatusBadge> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    Color dotColor;
    Color borderColor;

    switch (widget.type) {
      case BadgeType.onRoute:
      case BadgeType.boarded:
      case BadgeType.present:
        bgColor = AppColors.successBg;
        textColor = const Color(0xFF047857);
        dotColor = AppColors.success;
        borderColor = AppColors.successBorder;
        break;
      case BadgeType.exited:
        bgColor = const Color(0xFFE0F2FE);
        textColor = const Color(0xFF0369A1);
        dotColor = AppColors.accent;
        borderColor = const Color(0xFFBAE6FD);
        break;
      case BadgeType.warning:
      case BadgeType.pending:
        bgColor = AppColors.warningBg;
        textColor = const Color(0xFFB45309);
        dotColor = AppColors.warning;
        borderColor = AppColors.warningBorder;
        break;
      case BadgeType.absent:
      case BadgeType.emergency:
        bgColor = AppColors.dangerBg;
        textColor = const Color(0xFFB91C1C);
        dotColor = AppColors.danger;
        borderColor = AppColors.dangerBorder;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showDot) ...[
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withAlpha((_pulseController.value * 180).toInt()),
                        blurRadius: 6,
                        spreadRadius: 2 * _pulseController.value,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
          Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
