import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/language/language_cubit.dart';
import 'package:green_wheel/core/router/app_router.dart';
import 'package:green_wheel/core/theme/theme_cubit.dart';
import 'package:green_wheel/core/utils/local_storage.dart';

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;

  const MyApp({super.key, required this.localStorage});

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocBuilder<LanguageCubit, Locale>(
          builder: (context, locale) {
            return BlocBuilder<ThemeCubit, ThemeData>(
              builder: (context, theme) {
                return MaterialApp.router(
                  routerConfig: AppRouter.router,
                  debugShowCheckedModeBanner: false,
                  locale: locale,
                  localizationsDelegates: [
                    localizationDelegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  theme: theme,
                  supportedLocales: const [Locale('en', ''), Locale('ar', '')],

                  /// 👇 This is where we inject the overlay banner
                  builder: (context, child) {
                    return child!;
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
