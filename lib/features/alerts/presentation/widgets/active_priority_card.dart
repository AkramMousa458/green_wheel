import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';

class ActivePriorityCard extends StatelessWidget {
  final String title;
  final String description;
  final String pillText;
  final String buttonText;
  final IconData icon;
  final Color accentColor;
  final bool isButtonOutlined;
  final VoidCallback onTapButton;

  const ActivePriorityCard({
    super.key,
    required this.title,
    required this.description,
    required this.pillText,
    required this.buttonText,
    required this.icon,
    required this.accentColor,
    this.isButtonOutlined = false,
    required this.onTapButton,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.darkInputFill : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 12.h,
            bottom: 12.h,
            child: Container(
              width: 4.w,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(4.r),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w).copyWith(left: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        color: accentColor,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: accentColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  pillText.toUpperCase(),
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            description,
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 13.sp,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: onTapButton,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 10.h,
                              ),
                              decoration: BoxDecoration(
                                color: isButtonOutlined
                                    ? Colors.transparent
                                    : accentColor.withValues(alpha: 0.8),
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: isButtonOutlined
                                      ? accentColor
                                      : Colors.transparent,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                buttonText,
                                style: TextStyle(
                                  color: isButtonOutlined
                                      ? accentColor
                                      : (isDark
                                          ? AppColors.darkScaffold
                                          : AppColors.white),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
