import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:green_wheel/core/utils/local_storage.dart';

class LanguageCubit extends Cubit<Locale> {
  final LocalStorage localStorage;

  LanguageCubit({required this.localStorage, required Locale initialLocale})
    : super(initialLocale);

  /// Sets the language to Arabic
  Future<void> setArabic() async {
    emit(const Locale('ar', ''));
    await localStorage.saveLanguage('ar');
  }

  /// Sets the language to English
  Future<void> setEnglish() async {
    emit(const Locale('en', ''));
    await localStorage.saveLanguage('en');
  }

  /// Toggles between Arabic and English
  Future<void> toggleLanguage() async {
    if (state.languageCode == 'ar') {
      await setEnglish();
    } else {
      await setArabic();
    }
  }

  /// Gets the initial locale from storage or device settings
  static Future<Locale> getInitialLocale(LocalStorage localStorage) async {
    final savedLanguage = localStorage.language;
    if (savedLanguage == 'ar') {
      return const Locale('ar', '');
    }
    if (savedLanguage == 'en') {
      return const Locale('en', '');
    }
    // Default to English if no saved preference
    return const Locale('en', '');
  }

  /// Gets the initial locale from storage or device settings
  String getLanguage(context) {
    return LocalizedApp.of(context).delegate.currentLocale.languageCode;
  }
}
