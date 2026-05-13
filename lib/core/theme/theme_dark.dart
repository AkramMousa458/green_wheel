import 'package:flutter/material.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/app_string.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  fontFamily: AppString.fontFamily,

  // 1. Backgrounds
  scaffoldBackgroundColor: AppColors.darkScaffold,

  // 2. Color Scheme
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
    secondary:
        AppColors.primary, // Using primary as secondary often fits modern apps
    surface: AppColors.darkCard, // The Card background
    error: AppColors.error,
    onPrimary: AppColors.white,
    onSecondary: AppColors.white,
    onSurface: AppColors.darkTextPrimary, // White text on the card
    onError: AppColors.white,
    outline: AppColors.darkInputFill,
  ),

  // 3. AppBar Styling
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.darkScaffold,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.darkTextPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: AppString.fontFamily,
    ),
  ),

  // 4. Input Fields (Matches the screenshot's dark inputs)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkInputFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintStyle: TextStyle(
      color: AppColors.darkTextSecondary,
      fontFamily: AppString.fontFamily,
    ),
    labelStyle: TextStyle(
      color: AppColors.darkTextSecondary,
      fontFamily: AppString.fontFamily,
    ),

    // Border when not focused (Subtle or none)
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.transparent), // Clean look
    ),
    // Border when typing (Brand Blue)
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  ),

  // 5. Buttons (Same Brand Blue as Light Mode)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: AppString.fontFamily,
      ),
    ),
  ),

  // 6. Text Styling
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      color: AppColors.darkTextPrimary,
      fontWeight: FontWeight.bold,
      fontFamily: AppString.fontFamily,
    ),
    bodyMedium: TextStyle(
      color: AppColors.darkTextSecondary,
      fontFamily: AppString.fontFamily,
    ),
  ),
);
