import 'package:flutter/material.dart';
import '../models/game_models.dart';

class AppColors {
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceElevated = Color(0xFF1F2630);
  static const Color border = Color(0xFF2D3643);

  static const Color textPrimary = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  static const Color accentAmber = Color(0xFFF5A623);
  static const Color accentCrimson = Color(0xFFE05263);
  static const Color accentTeal = Color(0xFF2DD4BF);
  static const Color accentIndigo = Color(0xFF818CF8);
  static const Color accentSky = Color(0xFF38BDF8);
  static const Color success = Color(0xFF34D399);

  static Color forSkill(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return accentIndigo;
      case BrainSkill.focus:
        return accentAmber;
      case BrainSkill.logic:
        return accentTeal;
      case BrainSkill.math:
        return accentSky;
    }
  }

  static IconData iconForSkill(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return Icons.grid_view_rounded;
      case BrainSkill.focus:
        return Icons.center_focus_strong_rounded;
      case BrainSkill.logic:
        return Icons.extension_rounded;
      case BrainSkill.math:
        return Icons.calculate_rounded;
    }
  }
}

class AppTheme {
  static ThemeData darkTheme() {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentAmber,
        secondary: AppColors.accentTeal,
        surface: AppColors.surface,
        error: AppColors.accentCrimson,
        onPrimary: Color(0xFF111418),
        onSecondary: Color(0xFF0B1315),
        onSurface: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentAmber,
          foregroundColor: const Color(0xFF111418),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.2,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.accentAmber.withOpacity(0.16),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.accentAmber,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.accentAmber);
          }
          return const IconThemeData(color: AppColors.textSecondary);
        }),
      ),
    );
  }
}
