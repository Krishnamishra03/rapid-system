import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CurvedNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final int badgeCount;

  const CurvedNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    this.badgeCount = 0,
  });
}

class AnimatedCurvedNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<CurvedNavItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color unselectedColor;
  final Color curveBorderColor;

  const AnimatedCurvedNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor = Colors.white,
    this.activeColor = AppColors.accent,
    this.unselectedColor = AppColors.textMuted,
    this.curveBorderColor = AppColors.primary,
  });

  @override
  State<AnimatedCurvedNavigationBar> createState() => _AnimatedCurvedNavigationBarState();
}

class _AnimatedCurvedNavigationBarState extends State<AnimatedCurvedNavigationBar> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _animation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _previousIndex = widget.currentIndex;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animation = Tween<double>(
      begin: widget.currentIndex.toDouble(),
      end: widget.currentIndex.toDouble(),
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic));
  }

  @override
  void didUpdateWidget(covariant AnimatedCurvedNavigationBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _previousIndex = oldWidget.currentIndex;
      _animation = Tween<double>(
        begin: _previousIndex.toDouble(),
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic));
      _animController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int count = widget.items.length;
    final double itemWidth = screenWidth / count;
    final double barHeight = 70.0;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final double activeIndex = _animation.value;
        final double activeX = (activeIndex + 0.5) * itemWidth;

        return SizedBox(
          height: barHeight + bottomPadding + 10,
          width: screenWidth,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Custom Painted Curved Bar Background with Top Border Line & Neumorphic Shadow
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 10,
                child: CustomPaint(
                  size: Size(screenWidth, barHeight + bottomPadding),
                  painter: CurvedBarPainter(
                    activeX: activeX,
                    fillColor: widget.backgroundColor,
                    borderColor: widget.curveBorderColor,
                    borderWidth: 2.2,
                  ),
                ),
              ),

              // Unselected Icons & Labels Row
              Positioned(
                left: 0,
                right: 0,
                bottom: bottomPadding + 6,
                height: 54,
                child: Row(
                  children: List.generate(count, (index) {
                    final item = widget.items[index];
                    final isSelected = widget.currentIndex == index;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => widget.onTap(index),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Opacity(
                              opacity: isSelected ? 0.0 : 1.0,
                              child: Badge(
                                isLabelVisible: item.badgeCount > 0,
                                label: Text('${item.badgeCount}'),
                                backgroundColor: AppColors.accent,
                                child: Icon(
                                  item.icon,
                                  color: widget.unselectedColor,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                                color: isSelected ? AppColors.accent : widget.unselectedColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Floating Active Icon Circle Pill with Neumorphic Outset Shadow & Blue Gradient
              Positioned(
                left: (activeX - 26).clamp(0.0, screenWidth - 52.0),
                top: 0,
                child: GestureDetector(
                  onTap: () => widget.onTap(widget.currentIndex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withAlpha(120),
                          blurRadius: 18,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.white.withAlpha(200),
                          blurRadius: 10,
                          spreadRadius: -2,
                          offset: const Offset(-3, -3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        widget.items[widget.currentIndex].activeIcon ?? widget.items[widget.currentIndex].icon,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CurvedBarPainter extends CustomPainter {
  final double activeX;
  final double dipWidth;
  final double dipDepth;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;

  CurvedBarPainter({
    required this.activeX,
    this.dipWidth = 68.0,
    this.dipDepth = 24.0,
    this.fillColor = Colors.white,
    this.borderColor = AppColors.primary,
    this.borderWidth = 2.2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    // 1. Build Top Edge Curved Path
    final topCurvePath = Path();
    topCurvePath.moveTo(0, 0);
    topCurvePath.lineTo(activeX - dipWidth / 2 - 12, 0);

    topCurvePath.cubicTo(
      activeX - dipWidth / 2 + 4, 0,
      activeX - dipWidth / 3, dipDepth,
      activeX, dipDepth,
    );
    topCurvePath.cubicTo(
      activeX + dipWidth / 3, dipDepth,
      activeX + dipWidth / 2 - 4, 0,
      activeX + dipWidth / 2 + 12, 0,
    );

    topCurvePath.lineTo(size.width, 0);

    // 2. Build Full Closed Shape for Filling
    final bodyPath = Path.from(topCurvePath);
    bodyPath.lineTo(size.width, size.height);
    bodyPath.lineTo(0, size.height);
    bodyPath.close();

    // Fill Paint
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    // Draw Neumorphic Soft Elevation Shadow
    canvas.drawShadow(bodyPath, const Color(0xFFA3B1C6).withAlpha(80), 14, true);

    // Draw Filled Background
    canvas.drawPath(bodyPath, fillPaint);

    // 3. Draw Top Curve Border Line
    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(topCurvePath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CurvedBarPainter oldDelegate) {
    return oldDelegate.activeX != activeX ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.borderColor != borderColor;
  }
}
