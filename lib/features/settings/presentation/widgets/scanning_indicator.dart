import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';

class ScanningIndicator extends StatelessWidget {
  const ScanningIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 140.w,
          height: 140.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 8.w,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.bluetooth_searching_rounded,
              color: AppColors.primary,
              size: 56.sp,
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.1, 1.1),
          duration: 1.seconds,
          curve: Curves.easeInOut,
        );
  }
}
