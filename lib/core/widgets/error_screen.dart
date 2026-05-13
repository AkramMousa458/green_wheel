import 'package:flutter/material.dart';
import 'package:green_wheel/core/utils/app_styles.dart';

class ErrorScreen extends StatelessWidget {
  static const String routeName = '/error-screen';
  const ErrorScreen({super.key, this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            error ?? 'error, try again later',
            style: AppStyles.textstyle12,
          ),
        ),
      ),
    );
  }
}
