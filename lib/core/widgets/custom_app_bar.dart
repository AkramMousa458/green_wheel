import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/assets.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : AppColors.white,
      elevation: 0,
      toolbarHeight: 70,
      title: Image.asset(Assets.logoHorizontal, height: 40.h),
      // Text(
      //   translate('green_wheel').toUpperCase(),
      //   style: TextStyle(
      //     color: AppColors.primary,
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold,
      //     letterSpacing: 1.5,
      //   ),
      // ),
      centerTitle: true,
      leading: Icon(Icons.bolt_rounded, color: AppColors.primary),
      actions: [
        Icon(Icons.bluetooth_rounded, color: AppColors.primary),
        const SizedBox(width: 16),
      ],
    );
  }
}

