import 'package:green_wheel/core/constants.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A secure, type-safe wrapper around SharedPreferences for local data persistence.
/// Provides organized access to all local storage operations with proper error handling.
class LocalStorage {
  final Logger _logger;
  final SharedPreferences _prefs;

  /// Private constructor for singleton pattern
  LocalStorage._(this._prefs, {Logger? logger})
    : _logger =
          logger ??
          Logger(
            printer: PrettyPrinter(
              methodCount: 0,
              errorMethodCount: 5,
              lineLength: 80,
              colors: true,
              printEmojis: true,
            ),
          );

  /// Initializes and returns the LocalStorage instance
  static Future<LocalStorage> init({Logger? logger}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return LocalStorage._(prefs, logger: logger);
    } catch (e, stackTrace) {
      logger?.e(AppConstants.initFailedLog, error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // // ================== Authentication ================== //

  // /// Saves the authentication token
  // Future<bool> saveAuthToken(String token) {
  //   return setString(AppConstants.authTokenKey, token);
  // }

  // /// Retrieves the authentication token
  // String? get authToken => getString(AppConstants.authTokenKey);

  // /// Clears the authentication token
  // Future<bool> clearAuthToken() => remove(AppConstants.authTokenKey);

  //   /// Saves the refresh token
  // Future<bool> saveRefreshToken(String token) =>
  //     setString(AppConstants.refreshTokenKey, token);

  // /// Retrieves the refresh token
  // String? get refreshToken => getString(AppConstants.refreshTokenKey);

  // /// Clears the refresh token
  // Future<bool> clearRefreshToken() => remove(AppConstants.refreshTokenKey);

  // /// Logs out the user by clearing all session tokens
  // Future<void> logout() async {
  //   await clearAuthToken();
  //   await clearRefreshToken();
  //   clearUserProfile();
  // }

  // ================== User Preferences ================== //

  /// Saves the user's preferred theme mode (light/dark)
  Future<bool> saveThemeMode(bool isDarkMode) =>
      setBool(AppConstants.themeModeKey, isDarkMode);

  /// Retrieves the user's preferred theme mode
  bool get themeMode => getBool(AppConstants.themeModeKey) ?? false;

  /// Saves the user's language preference
  Future<bool> saveLanguage(String languageCode) =>
      setString(AppConstants.languageKey, languageCode);

  /// Retrieves the user's language preference
  String? get language => getString(AppConstants.languageKey);

  // ================== App State ================== //

  /// Checks if it's the user's first launch
  bool get isFirstLaunch => getBool(AppConstants.firstLaunchKey) ?? true;

  /// Marks the app as launched (not first launch anymore)
  Future<bool> markAppLaunched() => setBool(AppConstants.firstLaunchKey, false);

  // ================== Generic Methods ================== //

  Future<bool> setString(String key, String value) async {
    try {
      final success = await _prefs.setString(key, value);
      if (success) {
        _logger.d(
          AppConstants.saveSuccessLog,
          error: 'Key: $key, Value: $value',
        );
      }
      return success;
    } catch (e, stackTrace) {
      _logger.e(
        '${AppConstants.saveFailedLog} string',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e, stackTrace) {
      _logger.e(
        '${AppConstants.getFailedLog} string',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<bool> setBool(String key, bool value) async {
    try {
      final success = await _prefs.setBool(key, value);
      if (success) {
        _logger.d(
          AppConstants.saveSuccessLog,
          error: 'Key: $key, Value: $value',
        );
      }
      return success;
    } catch (e, stackTrace) {
      _logger.e(
        '${AppConstants.saveFailedLog} bool',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e, stackTrace) {
      _logger.e(
        '${AppConstants.getFailedLog} bool',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      final success = await _prefs.remove(key);
      if (success) {
        _logger.d(AppConstants.removeSuccessLog, error: 'Key: $key');
      }
      return success;
    } catch (e, stackTrace) {
      _logger.e(AppConstants.removeFailedLog, error: e, stackTrace: stackTrace);
      return false;
    }
  }

  /// Clears all stored data (use with caution)
  Future<bool> clearAll() async {
    try {
      final success = await _prefs.clear();
      if (success) {
        _logger.w(AppConstants.clearAllLog);
      }
      return success;
    } catch (e, stackTrace) {
      _logger.e(AppConstants.clearFailedLog, error: e, stackTrace: stackTrace);
      return false;
    }
  }
}
