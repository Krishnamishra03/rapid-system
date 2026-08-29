import 'package:flutter/material.dart';

class AppColors {
  // Premium Fintech Brand Palette
  static const Color primary = Color(0xFF0F172A); // Deep Obsidian Slate
  static const Color primaryLight = Color(0xFF1E293B); // Midnight Slate
  static const Color primaryDark = Color(0xFF020617); // Darkest Void

  static const Color accent = Color(0xFF2563EB); // Electric Royal Blue
  static const Color accentLight = Color(0xFF38BDF8); // Electric Sky Accent
  static const Color cyanNeon = Color(0xFF06B6D4); // Fintech Neon Cyan
  static const Color indigoGlow = Color(0xFF6366F1); // Indigo Accent

  // Semantic Status Colors
  static const Color success = Color(0xFF10B981); // Fintech Emerald Green
  static const Color successBg = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFFA7F3D0);

  static const Color warning = Color(0xFFF59E0B); // Amber Gold
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  static const Color danger = Color(0xFFEF4444); // Crimson Alert
  static const Color dangerBg = Color(0xFFFEF2F2);
  static const Color dangerBorder = Color(0xFFFECACA);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFEFF6FF);

  // Background & Neumorphic Canvas
  static const Color background = Color(0xFFF0F4F8); // Soft Fintech Light Grey-Blue Canvas
  static const Color surface = Colors.white;
  static const Color surfaceSubtle = Color(0xFFE2E8F0);
  static const Color surfaceCard = Color(0xFFF8FAFC);

  // Text Hierarchy
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textInverted = Colors.white;

  // Glassmorphism & Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassDarkBorder = Color(0x1A0F172A);

  // Fintech Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFF2563EB), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF0284C7), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sosGradient = LinearGradient(
    colors: [Color(0xFFB91C1C), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0xF2FFFFFF), Color(0xCCFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGlassGradient = LinearGradient(
    colors: [Color(0xE60F172A), Color(0xCC1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft Neumorphic Dual Shadows & Card Shadows
  static List<BoxShadow> get neumorphicOutset => [
        BoxShadow(
          color: const Color(0xFFA3B1C6).withAlpha(100),
          blurRadius: 16,
          spreadRadius: 1,
          offset: const Offset(6, 6),
        ),
        const BoxShadow(
          color: Colors.white,
          blurRadius: 16,
          spreadRadius: 1,
          offset: Offset(-6, -6),
        ),
      ];

  static List<BoxShadow> get neumorphicSoft => [
        BoxShadow(
          color: const Color(0xFFA3B1C6).withAlpha(70),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(4, 4),
        ),
        const BoxShadow(
          color: Colors.white,
          blurRadius: 10,
          spreadRadius: 0,
          offset: Offset(-4, -4),
        ),
      ];

  static List<BoxShadow> get cardShadow => neumorphicSoft;

  static List<BoxShadow> get primaryGlowShadow => [
        BoxShadow(
          color: primary.withAlpha(70),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get accentGlowShadow => [
        BoxShadow(
          color: accent.withAlpha(90),
          blurRadius: 20,
          spreadRadius: 2,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get sosGlowShadow => [
        BoxShadow(
          color: danger.withAlpha(90),
          blurRadius: 24,
          spreadRadius: 4,
          offset: const Offset(0, 6),
        ),
      ];
}
