import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_router/go_router.dart';
import 'package:green_wheel/core/utils/app_styles.dart';
import 'package:green_wheel/features/base/presentation/screens/base_screen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.action,
    this.isBack = true,
    this.backHomeDirect = false,
  });
  final String title;
  final Widget? action;
  final bool isBack;
  final bool backHomeDirect;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 20.h),

      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        // boxShadow: [AppStyles.boxShadow],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          isBack
              ? InkWell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 16.w,

                      color: Theme.of(context).appBarTheme.foregroundColor,
                    ),
                  ),
                  onTap: () => backHomeDirect
                      ? GoRouter.of(context).go(BaseScreen.routeName)
                      : Navigator.of(context).pop(),
                )
              : SizedBox.shrink(),
          Text(
            translate(title),
            style: AppStyles.textstyle16.copyWith(
              color: Theme.of(context).appBarTheme.foregroundColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          ...[if (action != null) action!],
        ],
      ),
    );
  }
}
