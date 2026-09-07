import 'package:flutter/material.dart';

abstract final class AppColors {
  static const ink = Color(0xFF20202A);
  static const mutedInk = Color(0xFF767386);
  static const primary = Color(0xFF5F33E1);
  static const primaryDark = Color(0xFF5125D6);
  static const primaryLight = Color(0xFF8B65F6);
  static const canvas = Color(0xFFF7F9FF);
  static const field = Color(0xFFF7F9FF);
  static const border = Color(0xFFE9EDF7);
  static const lavender = Color(0xFFEDE5FF);
  static const blush = Color(0xFFFFEAF2);
  static const mint = Color(0xFFE8FAF6);
  static const success = Color(0xFF37B24D);
  static const successSurface = Color(0xFFEBFBEE);
  static const danger = Color(0xFFE5484D);
  static const dangerSurface = Color(0xFFFFECEE);
  static const warning = Color(0xFFF08C00);
  static const warningSurface = Color(0xFFFFF4D6);
  static const infoSurface = Color(0xFFEDE5FF);
}

abstract final class AppSpacing {
  static const page = 20.0;
  static const section = 24.0;
  static const control = 12.0;
}

abstract final class AppRadii {
  static const page = 30.0;
  static const card = 16.0;
  static const control = 12.0;
}

abstract final class AppSizes {
  static const controlHeight = 48.0;
  static const icon = 20.0;
  static const navigationHeight = 64.0;
}

abstract final class AppTheme {
  static ThemeData light({required String fontFamily}) {
    const scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primaryLight,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: AppColors.ink,
      error: Color(0xFFBA1A1A),
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: AppColors.canvas,
      splashFactory: InkSparkle.splashFactory,
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 22,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 18,
          height: 1.25,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
        ),
        bodyLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 16,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: AppColors.mutedInk,
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 13,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 44,
          minHeight: 44,
        ),
        prefixIconColor: AppColors.mutedInk,
        suffixIconColor: AppColors.mutedInk,
        hintStyle: const TextStyle(
          color: Color(0xFFA5A1AF),
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: AppColors.mutedInk,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: const BorderSide(color: Color(0xFFE35D6A)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.control),
          borderSide: const BorderSide(color: Color(0xFFE35D6A), width: 1.5),
        ),
      ),
    );
  }
}
