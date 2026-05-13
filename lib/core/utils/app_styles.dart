import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:green_wheel/core/utils/app_string.dart';

abstract class AppStyles {
  static TextStyle textstyle20 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w500,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle20Bold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle30 = TextStyle(
    fontSize: 30.sp,
    fontWeight: FontWeight.w500,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle40 = TextStyle(
    fontSize: 40.sp,
    fontWeight: FontWeight.w600,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle25 = TextStyle(
    fontSize: 25.sp,
    fontWeight: FontWeight.w400,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle28 = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle18 = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle15 = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle16 = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle12 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w300,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle10 = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontFamily,
  );

  static TextStyle textstyle14 = TextStyle(
    fontSize: 14.sp,
    fontFamily: AppString.fontFamily,
  );
  static TextStyle textstyle14Bold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.bold,
    fontFamily: AppString.fontFamily,
  );

  static TextStyle textstyle22 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    fontFamily: AppString.fontFamily,
  );

  static TextStyle textstyle35Underline = TextStyle(
    fontSize: 35.sp,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
    fontFamily: AppString.fontFamily,
  );

  static TextStyle textstyle50Light = TextStyle(
    fontSize: 50.sp,
    fontWeight: FontWeight.w300,
    fontFamily: AppString.fontFamily,
  );

  static TextStyle textstyle18ColorRed = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.error500,
    fontFamily: AppString.fontFamily,
  );
  static BoxShadow boxShadow = BoxShadow(
    color: AppColors.grey.withValues(alpha: 0.3),
    blurRadius: 34.r,
    spreadRadius: 0,
    offset: Offset(0, 0), // changes position of shadow
  );
}
