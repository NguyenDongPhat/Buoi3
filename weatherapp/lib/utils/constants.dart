class AppConstants {
  // API
  static const String openweatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String openweatherIconUrl = 'https://openweathermap.org/img/wn';
  
  // Storage keys
  static const String cachedWeatherKey = 'cached_weather';
  static const String lastUpdateKey = 'last_update';
  static const String favoriteCitiesKey = 'favorite_cities';
  static const String searchHistoryKey = 'search_history';
  
  // Cache duration
  static const int cacheDurationMinutes = 30;
  
  // UI
  static const double cardBorderRadius = 20.0;
  static const double cardElevation = 4.0;
}
