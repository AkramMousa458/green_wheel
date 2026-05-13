import 'package:flutter/material.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/app_string.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  fontFamily: AppString.fontFamily,

  // 1. Backgrounds
  scaffoldBackgroundColor: AppColors.lightScaffold,

  // 2. Color Scheme (The core palette)
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    secondary: AppColors.grey,
    surface: AppColors.lightCard, // The Card background (White)
    error: AppColors.error,
    onPrimary: AppColors.white, // Text on Blue button
    onSecondary: AppColors.white,
    onSurface: AppColors.lightTextPrimary, // Text on White Card (Dark Slate)
    onError: AppColors.white,
    outline: AppColors.lightBorder, // For input borders
  ),

  // 3. AppBar Styling
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.lightScaffold,
    elevation: 0,
    centerTitle: true,
    iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    titleTextStyle: TextStyle(
      color: AppColors.lightTextPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      fontFamily: AppString.fontFamily,
    ),
  ),

  // 4. Input Fields (Matches the "Mobile Number" field style)
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightInputFill,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintStyle: TextStyle(
      color: AppColors.lightTextSecondary,
      fontFamily: AppString.fontFamily,
    ),
    labelStyle: TextStyle(
      color: AppColors.lightTextSecondary,
      fontFamily: AppString.fontFamily,
    ),
    // Border when not focused
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.lightBorder),
    ),
    // Border when typing
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error),
    ),
  ),

  // 5. Buttons (Matches the "Send Verification Code" button)
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Pill shape
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        fontFamily: AppString.fontFamily,
      ),
    ),
  ),

  // 6. Text Styling defaults
  textTheme: TextTheme(
    headlineMedium: TextStyle(
      // For "Let's get moving!"
      color: AppColors.lightTextPrimary,
      fontWeight: FontWeight.bold,
      fontFamily: AppString.fontFamily,
    ),
    bodyMedium: TextStyle(
      // For instructions
      color: AppColors.lightTextSecondary,
      fontFamily: AppString.fontFamily,
    ),
  ),
);
