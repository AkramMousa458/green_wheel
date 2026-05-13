// Custom Colors
import 'package:flutter/material.dart';

/// A central class to hold all color constants used throughout the application.
class AppColors {
  // --------------------------------------------------------------------------
  // 1. SHARED BRAND COLORS (Used in both Light and Dark modes)
  // --------------------------------------------------------------------------
static const Color primary = Color(0xFF00ff41);
  static const Color secondary = Color(0xFF008e24);
  // static const Color primarySoft = Color(0xFFFFBD6C);
  // static const Color primaryDark = Color.fromARGB(255, 185, 102, 0);
  static const Color grey = Color(0xFF64748B); // A useful medium grey
  static const Color error = Color(0xFFEF4444); // Red for errors
  static const Color error500 = Color(0xFFF04438);
  static const Color white = Colors.white; // Pure white
  static const Color black = Colors.black; // Pure black
  static const Color transparent = Colors.transparent;
  static const Color warning500 = Color(0xFFF79009);
  static const Color success500 = Color(0xFF12B76A);

  // --------------------------------------------------------------------------
  // 2. DARK THEME PALETTE
  // --------------------------------------------------------------------------

  /// Deepest Navy used for the main Scaffold background.
  static const Color darkScaffold = Color(0xFF0F172A);

  /// Lighter Navy used for surfaces like Cards and Dialogs (matches the login sheet).
  static const Color darkCard = Color(0xFF1E293B);

  /// Dark Grey/Blue fill for TextFields and Inputs.
  static const Color darkInputFill = Color(0xFF334155);

  /// Color for primary text (Headings, titles) on dark surfaces.
  static const Color darkTextPrimary = white;

  /// Color for secondary text (Body copy, hints) on dark surfaces.
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  // --------------------------------------------------------------------------
  // 3. LIGHT THEME PALETTE
  // --------------------------------------------------------------------------

  /// Very pale blue-grey used for the main Scaffold background.
  static const Color lightScaffold = Color(0xFFF1F5F9);

  /// Pure white used for surfaces like Cards and Dialogs.
  static const Color lightCard = white;

  /// Very light grey fill for TextFields and Inputs.
  static const Color lightInputFill = Color(0xFFF8FAFC);

  /// Color for borders and dividers in the light theme.
  static const Color lightBorder = Color(0xFFE2E8F0);

  /// Dark Slate color for primary text (Headings, titles) on light surfaces.
  static const Color lightTextPrimary = Color(0xFF0F172A);

  /// Medium Grey color for secondary text (Body copy, hints) on light surfaces.
  static const Color lightTextSecondary = Color(0xFF64748B);

  static const Color shimmerDarkBaseColor = AppColors.darkCard;
  static Color shimmerLightBaseColor = Colors.grey[300]!;

  static const Color shimmerDarkHighlightColor = AppColors.darkInputFill;
  static Color shimmerLightHighlightColor = Colors.grey[100]!;

  static const Color shimmerDarkCardColor = AppColors.darkCard;
  static Color shimmerLightCardColor = Colors.white;
}

// class AppColors {
//   static const Color primary = Color(0xFF2667ec); // Updated primary color
// static const Color secondary = Color(0xFF39e965);
// static const Color primarySoft = Color(0xFF397ff6);
// static const Color primaryDark = Color(0xFF142247);
// static const Color error = Color(0xFFD32F2F);
// static const Color error500 = Color(0xFFF04438);
//   static const Color scaffoldBackground = Color(0xFFF5F5F5);
//   static const Color surface = Color(0xFF1E2028);
//   static const Color white = Color(0xFFFFFFFF);
//   static const Color inputBorder = Color(0xFFBDBDBD);
//   static const Color inputFill = Color(0xFFF5F5F5);
//   static const Color divider = Color(0xFFE0E0E0);
//   static const Color secondText = Color(0xFF736B7A);
//   static const Color blackText = Color(0xFF1E1E1E);
//   static const Color appBarBackground = Color(0xFFEFF6FE);
//   static const Color secondText2 = Color(0xFFB5B5B5);
// static const Color warning500= Color(0xFFF79009);
// static const Color baseSurface= Color(0xFF4D5168);
// static const Color success500= Color(0xFF12B76A);
// }
