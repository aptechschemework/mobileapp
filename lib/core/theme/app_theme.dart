import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        onPrimary: AppColors.onPrimaryLight,
        primaryContainer: AppColors.primaryContainerLight,
        onPrimaryContainer: AppColors.onPrimaryContainerLight,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.onSecondaryLight,
        secondaryContainer: AppColors.secondaryContainerLight,
        onSecondaryContainer: AppColors.onSecondaryContainerLight,
        background: AppColors.backgroundLight,
        onBackground: AppColors.onBackgroundLight,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
        surfaceVariant: AppColors.surfaceVariantLight,
        onSurfaceVariant: AppColors.onSurfaceVariantLight,
        outline: AppColors.outlineLight,
        error: AppColors.errorLight,
        onError: AppColors.onErrorLight,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.onBackgroundLight),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.onBackgroundLight),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackgroundLight),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurfaceLight),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurfaceLight),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.onSurfaceLight),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariantLight),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariantLight),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryLight),
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.onBackgroundLight),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.onPrimaryLight,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        onPrimary: AppColors.onPrimaryDark,
        primaryContainer: AppColors.primaryContainerDark,
        onPrimaryContainer: AppColors.onPrimaryContainerDark,
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.onSecondaryDark,
        secondaryContainer: AppColors.secondaryContainerDark,
        onSecondaryContainer: AppColors.onSecondaryContainerDark,
        background: AppColors.backgroundDark,
        onBackground: AppColors.onBackgroundDark,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
        surfaceVariant: AppColors.surfaceVariantDark,
        onSurfaceVariant: AppColors.onSurfaceVariantDark,
        outline: AppColors.outlineDark,
        error: AppColors.errorDark,
        onError: AppColors.onErrorDark,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(color: AppColors.onBackgroundDark),
        headlineLarge: AppTextStyles.headlineLarge.copyWith(color: AppColors.onBackgroundDark),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(color: AppColors.onBackgroundDark),
        titleLarge: AppTextStyles.titleLarge.copyWith(color: AppColors.onSurfaceDark),
        titleMedium: AppTextStyles.titleMedium.copyWith(color: AppColors.onSurfaceDark),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(color: AppColors.onSurfaceDark),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceVariantDark),
        bodySmall: AppTextStyles.bodySmall.copyWith(color: AppColors.onSurfaceVariantDark),
        labelLarge: AppTextStyles.labelLarge.copyWith(color: AppColors.primaryDark),
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.onBackgroundDark),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.onPrimaryDark,
        elevation: 4,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
