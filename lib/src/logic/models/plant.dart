// import 'package:flutter/material.dart';

// Represents a single plant in the digital garden.
// This is a view-model, meaning it's tailored for the UI and derived
// from the core journal entry data.
class Plant {
  // A value from 0.0 to 1.0 representing how much the plant has grown.
  // This could be based on the number of entries.
  final double growth;

  // A value from 0.0 to 1.0 representing the plant's health/vibrancy.
  // This could be based on how recently the user has written an entry.
  final double vibrancy;

  Plant({
    required this.growth,
    required this.vibrancy,
  });
}