import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/app_styles.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmButtonText,
    required this.cancelButtonText,
    required this.onConfirm,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeUtils.isDark(context);

    return AlertDialog(
      backgroundColor: isDark ? AppColors.darkCard : AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        title,
        style: AppStyles.textstyle18.copyWith(
          color: isDark ? AppColors.white : AppColors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: AppStyles.textstyle14.copyWith(
          color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            cancelButtonText,
            style: AppStyles.textstyle14.copyWith(
              color: isDark ? AppColors.white : AppColors.black,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog first
            onConfirm();
          },
          child: Text(
            confirmButtonText,
            style: AppStyles.textstyle14.copyWith(
              color: isDestructive ? AppColors.error : AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
