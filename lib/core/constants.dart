/// Constants for SharedPreferences keys and storage-related values
class AppConstants {
  // Authentication keys
  static const String authTokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';

  // User preferences keys
  static const String themeModeKey = 'theme_dark';
  static const String languageKey = 'language';
  static const String userProfileKey = 'user_profile';

  // App state keys
  static const String firstLaunchKey = 'first_launch';

  // Cache keys
  static const String servicesKey = 'cached_services';
  static const String homeSectionsKey = 'cached_home_sections';
  static const String statisticsKey = 'cached_statistics';
  static const String contactKey = 'cached_contact';

  // Log messages
  static const String saveSuccessLog = 'Saved to local storage';
  static const String removeSuccessLog = 'Removed from local storage';
  static const String clearAllLog = 'Cleared all local storage data';
  static const String initFailedLog = 'Failed to initialize LocalStorage';
  static const String saveFailedLog = 'Failed to save';
  static const String getFailedLog = 'Failed to get';
  static const String removeFailedLog = 'Failed to remove';
  static const String clearFailedLog = 'Failed to clear storage';
}
