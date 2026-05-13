import 'package:flutter/material.dart';

/// Utility functions for theme-related operations
class ThemeUtils {
  /// Checks if the current theme is dark mode
  ///
  /// Usage:
  /// ```dart
  /// final isDark = ThemeUtils.isDark(context);
  /// ```
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Checks if the current theme is light mode
  ///
  /// Usage:
  /// ```dart
  /// final isLight = ThemeUtils.isLight(context);
  /// ```
  static bool isLight(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light;
  }
}
