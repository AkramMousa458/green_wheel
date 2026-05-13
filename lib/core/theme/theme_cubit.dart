import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:green_wheel/core/theme/theme_dark.dart';
import 'package:green_wheel/core/theme/theme_light.dart';
import 'package:green_wheel/core/utils/local_storage.dart';

class ThemeCubit extends Cubit<ThemeData> {
  final LocalStorage localStorage;
  static const String _themeKey = 'theme_mode';

  ThemeCubit({
    required this.localStorage,
    required Brightness initialBrightness,
  }) : super(initialBrightness == Brightness.dark ? darkTheme : lightTheme);

  void setLightTheme() {
    emit(lightTheme);
    localStorage.setString(_themeKey, 'light');
  }

  void setDarkTheme() {
    emit(darkTheme);
    localStorage.setString(_themeKey, 'dark');
  }

  void toggleTheme() {
    if (state.brightness == Brightness.dark) {
      setLightTheme();
    } else {
      setDarkTheme();
    }
  }

  // static Brightness getDeviceBrightness() {
  //   return PlatformDispatcher.instance.platformBrightness;
  // }

  // static Future<Brightness> getInitialBrightness(
  //   LocalStorage localStorage,
  // ) async {
  //   final saved = localStorage.getString(_themeKey);
  //   if (saved == 'dark') return Brightness.dark;
  //   if (saved == 'light') return Brightness.light;
  //   return getDeviceBrightness();
  // }
}
