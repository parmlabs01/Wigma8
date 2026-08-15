import 'package:flutter/material.dart';

/// Wigma 8 brand color system, exactly as specified in the PRD.
/// Premium, modern, minimal — white surfaces with deep navy structure
/// and a single blue accent used sparingly for CTAs and highlights.
class AppColors {
  AppColors._();

  // Core brand palette
  static const Color background = Color(0xFFFFFFFF); // Primary Background
  static const Color primaryNavy = Color(0xFF0F172A); // Primary Brand Color
  static const Color secondaryNavy = Color(0xFF1E293B); // Secondary Navy
  static const Color accent = Color(0xFF3B82F6); // Accent Color
  static const Color textPrimary = Color(0xFF111827); // Text

  // Derived / support tones (not in PRD, needed for a usable UI)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE5E7EB);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnNavy = Color(0xFFF8FAFC);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  // Dark mode surfaces
  static const Color darkBackground = Color(0xFF0B1120);
  static const Color darkSurface = Color(0xFF111827);
  static const Color darkBorder = Color(0xFF1F2937);

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
  );

  static const LinearGradient navyGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryNavy, secondaryNavy],
  );
}
