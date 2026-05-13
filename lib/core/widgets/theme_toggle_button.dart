import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/theme/theme_cubit.dart';
import 'package:green_wheel/core/utils/theme_utils.dart';

/// A reusable theme toggle button widget
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeData>(
      builder: (context, theme) {
        final isDark = ThemeUtils.isDark(context);

        return InkWell(
          onTap: () {
            context.read<ThemeCubit>().toggleTheme();
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  size: 20.w,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
                SizedBox(width: 4.w),
                // Text(
                //   isDark ? 'Light' : 'Dark',
                //   style: TextStyle(
                //     fontSize: 14.sp,
                //     fontWeight: FontWeight.w600,
                //     color: Theme.of(context).appBarTheme.foregroundColor,
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
