import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/app_colors.dart';
import 'package:go_router/go_router.dart';

class AppDialogs {
  static void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate('confirm_logout')),
        content: Text(translate('logout_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              // context.read<AppCubit>().logout();
            },
            child: Text(
              translate('log_out'),
              style: TextStyle(color: AppColors.error500),
            ),
          ),
        ],
      ),
    );
  }

  static void showDeleteProfilePhotoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translate('confirm_delete_profile_photo')),
        content: Text(translate('delete_profile_photo_message')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              // context.read<ProfileCubit>().deleteProfileImage();
            },
            child: Text(
              translate('delete'),
              style: TextStyle(color: AppColors.error500),
            ),
          ),
        ],
      ),
    );
  }
}
