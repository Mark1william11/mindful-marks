import 'package:flutter/material.dart';

// This class holds all the custom color palettes for the app.
class AppColors {
  // Prevent instantiation
  AppColors._();

  // MAIN PALETTE
  static const Color primary = Color(0xFF2A4A43); // A deep, calming forest green
  static const Color primaryVariant = Color(0xFF3E6B5F); // A slightly lighter, muted green
  static const Color secondary = Color(0xFFF4A261); // A warm, vibrant orange for accents
  static const Color background = Color(0xFFF7F5F2); // A soft, off-white, like parchment
  static const Color onBackground = Color(0xFF1B1C1E); // A dark charcoal for text
  static const Color surface = Colors.white; // For cards and surfaces
  static const Color onSurface = Color(0xFF1B1C1E); // Text on surfaces

  // System Colors
  static const Color error = Color(0xFFB00020);
  static const Color onError = Colors.white;
}