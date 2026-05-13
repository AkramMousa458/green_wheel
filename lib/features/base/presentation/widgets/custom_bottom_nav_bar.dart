import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/app_styles.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom > 0 ? 0 : 10.h,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 65.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.grid_view_outlined,
                selectedIcon: Icons.grid_view_rounded,
                label: 'dashboard',
                fallbackText: 'لوحة القيادة',
                index: 0,
                isDark: isDark,
                primaryColor: primaryColor,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.insights_outlined,
                selectedIcon: Icons.insights_rounded,
                label: 'analytics',
                fallbackText: 'التحليلات',
                index: 1,
                isDark: isDark,
                primaryColor: primaryColor,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.notifications_none_rounded,
                selectedIcon: Icons.notifications_rounded,
                label: 'alerts',
                fallbackText: 'تنبيهات',
                index: 2,
                isDark: isDark,
                primaryColor: primaryColor,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.settings_outlined,
                selectedIcon: Icons.settings_rounded,
                label: 'settings',
                fallbackText: 'إعدادات',
                index: 3,
                isDark: isDark,
                primaryColor: primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required String fallbackText,
    required int index,
    required bool isDark,
    required Color primaryColor,
  }) {
    final isSelected = selectedIndex == index;
    final color = isSelected
        ? primaryColor
        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary);

    // Using translate, if it simply returns the key because it isn't defined yet, we fall back to the direct Arabic string.
    String translatedText = translate(label);
    if (translatedText == label) {
      translatedText = fallbackText;
    }

    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? selectedIcon : icon,
                key: ValueKey(isSelected),
                color: color,
                size: 26.sp,
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppStyles.textstyle10.copyWith(
                color: color,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
              child: Text(translatedText),
            ),
          ],
        ),
      ),
    );
  }
}
