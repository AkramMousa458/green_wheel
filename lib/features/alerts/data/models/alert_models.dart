import 'package:flutter/material.dart';

class ActivePriorityModel {
  final String titleKey;
  final String descriptionKey;
  final String pillTextKey;
  final String buttonTextKey;
  final IconData icon;
  final Color accentColor;
  final bool isButtonOutlined;

  const ActivePriorityModel({
    required this.titleKey,
    required this.descriptionKey,
    required this.pillTextKey,
    required this.buttonTextKey,
    required this.icon,
    required this.accentColor,
    this.isButtonOutlined = false,
  });
}

class RecentEventModel {
  final String titleKey;
  final String descriptionKey;
  final String timeKey;
  final IconData icon;
  final bool isPrimaryColor;

  const RecentEventModel({
    required this.titleKey,
    required this.descriptionKey,
    required this.timeKey,
    required this.icon,
    this.isPrimaryColor = false,
  });
}
