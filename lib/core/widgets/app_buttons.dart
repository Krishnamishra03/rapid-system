import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

enum AppButtonType { primary, secondary, danger, outline, success }

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height = 54,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Gradient? gradient;
    Color bgColor;
    Color fgColor = Colors.white;
    BorderSide borderSide = BorderSide.none;
    List<BoxShadow> shadows = [];

    switch (widget.type) {
      case AppButtonType.primary:
        gradient = AppColors.primaryGradient;
        bgColor = AppColors.primary;
        shadows = AppColors.primaryGlowShadow;
        break;
      case AppButtonType.secondary:
        gradient = AppColors.accentGradient;
        bgColor = AppColors.accent;
        shadows = AppColors.accentGlowShadow;
        break;
      case AppButtonType.danger:
        gradient = AppColors.sosGradient;
        bgColor = AppColors.danger;
        shadows = AppColors.sosGlowShadow;
        break;
      case AppButtonType.success:
        gradient = AppColors.successGradient;
        bgColor = AppColors.success;
        shadows = [
          BoxShadow(
            color: AppColors.success.withAlpha(80),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ];
        break;
      case AppButtonType.outline:
        bgColor = Colors.transparent;
        fgColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.border, width: 1.8);
        break;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: widget.type != AppButtonType.outline ? gradient : null,
            color: widget.type == AppButtonType.outline ? Colors.transparent : bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: widget.type != AppButtonType.outline ? shadows : null,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: fgColor,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: borderSide,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            onPressed: widget.isLoading ? null : widget.onPressed,
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(fgColor),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20, color: fgColor),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          widget.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: fgColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
