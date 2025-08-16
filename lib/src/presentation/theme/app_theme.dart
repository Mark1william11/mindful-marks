import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: AppColors.error,
        onError: AppColors.onError,
      ),
      
      textTheme: TextTheme(
        // For headlines and titles
        displayLarge: GoogleFonts.merriweather(fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.onBackground),
        displayMedium: GoogleFonts.merriweather(fontSize: 45, fontWeight: FontWeight.bold, color: AppColors.onBackground),
        displaySmall: GoogleFonts.merriweather(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.onBackground),
        
        headlineLarge: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.onBackground),
        headlineMedium: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.onBackground),
        headlineSmall: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.onBackground),

        // For body text and captions
        bodyLarge: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.onBackground),
        bodyMedium: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.onBackground),
        bodySmall: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.onBackground),
        
        // For buttons
        labelLarge: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.lato(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}