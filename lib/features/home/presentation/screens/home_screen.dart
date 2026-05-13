import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/widgets/custom_app_bar.dart';
import 'package:green_wheel/features/home/presentation/widgets/home_screen_body.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home-screen';

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.h),
        child: CustomAppBar(isDark: isDark),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
          onRefresh: () async {},
          child: const HomeScreenBody(),
        ),
      ),
    );
  }
}

