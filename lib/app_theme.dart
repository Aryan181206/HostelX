import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF24389C);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF3F51B5);
  static const Color onPrimaryContainer = Color(0xFFCACFFF);
  static const Color primaryFixed = Color(0xFFDEE0FF);
  static const Color primaryFixedDim = Color(0xFFBAC3FF);
  static const Color onPrimaryFixed = Color(0xFF00105C);
  static const Color onPrimaryFixedVariant = Color(0xFF293CA0);
  static const Color inversePrimary = Color(0xFFBAC3FF);

  // Secondary
  static const Color secondary = Color(0xFF006B5C);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFF68FADE);
  static const Color onSecondaryContainer = Color(0xFF007162);
  static const Color secondaryFixed = Color(0xFF68FADE);
  static const Color secondaryFixedDim = Color(0xFF44DDC2);
  static const Color onSecondaryFixed = Color(0xFF00201B);
  static const Color onSecondaryFixedVariant = Color(0xFF005045);

  // Tertiary
  static const Color tertiary = Color(0xFF5E3C00);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF7D5100);
  static const Color onTertiaryContainer = Color(0xFFFFC980);
  static const Color tertiaryFixed = Color(0xFFFFDDB4);
  static const Color tertiaryFixedDim = Color(0xFFFFB954);
  static const Color onTertiaryFixed = Color(0xFF291800);
  static const Color onTertiaryFixedVariant = Color(0xFF633F00);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surfaces & Backgrounds
  static const Color background = Color(0xFFF7F9FC);
  static const Color onBackground = Color(0xFF191C1E);
  static const Color surface = Color(0xFFF7F9FC);
  static const Color onSurface = Color(0xFF191C1E);
  static const Color surfaceVariant = Color(0xFFE0E3E6);
  static const Color onSurfaceVariant = Color(0xFF454652);
  static const Color inverseSurface = Color(0xFF2D3133);
  static const Color inverseOnSurface = Color(0xFFEFF1F4);

  // Surface Containers
  static const Color surfaceBright = Color(0xFFF7F9FC);
  static const Color surfaceDim = Color(0xFFD8DADD);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F4F7);
  static const Color surfaceContainer = Color(0xFFECEEF1);
  static const Color surfaceContainerHigh = Color(0xFFE6E8EB);
  static const Color surfaceContainerHighest = Color(0xFFE0E3E6);
  static const Color surfaceTint = Color(0xFF4355B9);

  // Outlines
  static const Color outline = Color(0xFF757684);
  static const Color outlineVariant = Color(0xFFC5C5D4);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceVariant: AppColors.surfaceVariant,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: TextTheme(
        // Mapping your Tailwind fonts (Headline: Manrope, Body/Label: Inter)
        displayLarge: GoogleFonts.manrope(color: AppColors.onSurface),
        displayMedium: GoogleFonts.manrope(color: AppColors.onSurface),
        displaySmall: GoogleFonts.manrope(color: AppColors.onSurface),
        headlineLarge: GoogleFonts.manrope(color: AppColors.onSurface),
        headlineMedium: GoogleFonts.manrope(color: AppColors.onSurface),
        headlineSmall: GoogleFonts.manrope(color: AppColors.onSurface),
        titleLarge: GoogleFonts.manrope(color: AppColors.onSurface),
        titleMedium: GoogleFonts.inter(color: AppColors.onSurface),
        titleSmall: GoogleFonts.inter(color: AppColors.onSurface),
        bodyLarge: GoogleFonts.inter(color: AppColors.onSurface),
        bodyMedium: GoogleFonts.inter(color: AppColors.onSurface),
        bodySmall: GoogleFonts.inter(color: AppColors.onSurface),
        labelLarge: GoogleFonts.inter(color: AppColors.onSurface),
        labelMedium: GoogleFonts.inter(color: AppColors.onSurface),
        labelSmall: GoogleFonts.inter(color: AppColors.onSurface),
      ),
    );
  }
}