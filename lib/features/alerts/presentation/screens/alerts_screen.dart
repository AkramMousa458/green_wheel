import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';
import 'package:green_wheel/features/alerts/presentation/widgets/alerts_screen_body.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});
  static const String routeName = '/alerts-screen';

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? Theme.of(context).scaffoldBackgroundColor
            : AppColors.white,
        elevation: 0,
        toolbarHeight: 70,
        title: Text(
          translate('green_wheel').toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        leading: const Icon(Icons.bolt_rounded, color: AppColors.primary),
        actions: const [
          Icon(Icons.bluetooth_rounded, color: AppColors.primary),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
          onRefresh: () async {},
          child: const AlertsScreenBody(),
        ),
      ),
    );
  }
}
