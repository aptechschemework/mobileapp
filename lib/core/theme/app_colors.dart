import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors
  static const Color primaryLight = Color(0xFF5A46E5); // Indigo/Blue-violet
  static const Color onPrimaryLight = Colors.white;
  static const Color primaryContainerLight = Color(0xFFE8E5FF);
  static const Color onPrimaryContainerLight = Color(0xFF160067);

  static const Color secondaryLight = Color(0xFF5D5C71);
  static const Color onSecondaryLight = Colors.white;
  static const Color secondaryContainerLight = Color(0xFFE2E1F9);
  static const Color onSecondaryContainerLight = Color(0xFF1A1A2C);

  static const Color backgroundLight = Color(0xFFFBFBFF);
  static const Color surfaceLight = Colors.white;
  static const Color onBackgroundLight = Color(0xFF1B1B1F);
  static const Color onSurfaceLight = Color(0xFF1B1B1F);
  static const Color surfaceVariantLight = Color(0xFFE4E1EC);
  static const Color onSurfaceVariantLight = Color(0xFF46464F);

  static const Color outlineLight = Color(0xFF777680);
  static const Color errorLight = Color(0xFFBA1A1A);
  static const Color onErrorLight = Colors.white;

  // Dark Theme Colors
  static const Color primaryDark = Color(0xFFC4C0FF);
  static const Color onPrimaryDark = Color(0xFF2A009A);
  static const Color primaryContainerDark = Color(0xFF412BB3);
  static const Color onPrimaryContainerDark = Color(0xFFE8E5FF);

  static const Color secondaryDark = Color(0xFFC6C5DD);
  static const Color onSecondaryDark = Color(0xFF2F2F42);
  static const Color secondaryContainerDark = Color(0xFF454559);
  static const Color onSecondaryContainerDark = Color(0xFFE2E1F9);

  static const Color backgroundDark = Color(0xFF1B1B1F);
  static const Color surfaceDark = Color(0xFF121214);
  static const Color onBackgroundDark = Color(0xFFE4E1E6);
  static const Color onSurfaceDark = Color(0xFFE4E1E6);
  static const Color surfaceVariantDark = Color(0xFF46464F);
  static const Color onSurfaceVariantDark = Color(0xFFC8C5D0);

  static const Color outlineDark = Color(0xFF91909A);
  static const Color errorDark = Color(0xFFFFB4AB);
  static const Color onErrorDark = Color(0xFF690005);

  // Soft Color Palette for Note Editors (Light/Dark variants handled via opacity or custom tinting)
  static const List<Color> noteColors = [
    Colors.transparent, // Default/None
    Color(0xFFFFD6D6), // Soft Red
    Color(0xFFFFEAA7), // Soft Yellow
    Color(0xFFD4EDDA), // Soft Green
    Color(0xFFD1ECF1), // Soft Blue
    Color(0xFFE2D9F3), // Soft Purple
    Color(0xFFF8D7DA), // Soft Pink
    Color(0xFFE2E3E5), // Soft Gray
  ];

  static const List<Color> noteColorsDark = [
    Colors.transparent,
    Color(0xFF5C2D2D),
    Color(0xFF5C532D),
    Color(0xFF2D5C3B),
    Color(0xFF2D515C),
    Color(0xFF3F2D5C),
    Color(0xFF5C2D49),
    Color(0xFF3A3A3C),
  ];
}
