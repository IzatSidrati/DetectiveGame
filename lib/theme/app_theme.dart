import 'package:flutter/material.dart';
import '../models/game_models.dart';

class AppColors {
  // Atmospheric Dark Horror Palette (Old Indonesian Hospital Corridor)
  static const Color background = Color(0xFF070B0E);
  static const Color surface = Color(0xFF0E1519);
  static const Color surfaceElevated = Color(0xFF152026);
  static const Color border = Color(0xFF22333B);

  static const Color textPrimary = Color(0xFFE5F0EF);
  static const Color textSecondary = Color(0xFF8CA6A8);
  static const Color textMuted = Color(0xFF566E72);

  // Flashlight yellow, eerie pale hospital teal, emergency crimson
  static const Color accentAmber = Color(0xFFF0C040); // Flashlight beam yellow
  static const Color accentCrimson = Color(0xFFDC2626); // Emergency red
  static const Color accentTeal = Color(0xFF5FA8A0); // Pale eerie teal
  static const Color accentIndigo = Color(0xFF7EC8C0); // Spectral mist teal
  static const Color accentSky = Color(0xFF8BB8C4); // Cold fluorescent blue-grey
  static const Color success = Color(0xFF4EA885); // Dim hospital monitor green

  static Color forSkill(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return accentIndigo; // Usap Cermin (Mist)
      case BrainSkill.focus:
        return accentAmber; // Selaraskan Diktafon (Flashlight)
      case BrainSkill.logic:
        return accentTeal; // Susun Sesajen (Eerie Teal)
      case BrainSkill.math:
        return accentCrimson; // Tahan Napas (Emergency Red)
    }
  }

  static IconData iconForSkill(BrainSkill skill) {
    switch (skill) {
      case BrainSkill.memory:
        return Icons.blur_on_rounded; // Mirror fog
      case BrainSkill.focus:
        return Icons.graphic_eq_rounded; // Dictaphone frequency
      case BrainSkill.logic:
        return Icons.local_fire_department_rounded; // Ritual offerings
      case BrainSkill.math:
        return Icons.monitor_heart_rounded; // Heartbeat / Hold breath
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
        onPrimary: Color(0xFF0A0F12),
        onSecondary: Color(0xFF070C0E),
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
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentAmber,
          foregroundColor: const Color(0xFF0A0F12),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            letterSpacing: 0.4,
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
        indicatorColor: AppColors.accentTeal.withOpacity(0.18),
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
