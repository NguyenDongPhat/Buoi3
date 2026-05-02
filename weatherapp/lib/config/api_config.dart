class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static String? _apiKey;
  
  // Endpoints
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';
  
  // Set API key at runtime
  static void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }
  
  // Get API key
  static String get apiKey => _apiKey ?? '';
  
  // Build URL
  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$baseUrl$endpoint');
    params['appid'] = apiKey;
    // Only set default units when caller did not provide one
    if (!params.containsKey('units')) {
      params['units'] = 'metric'; // default
    }
    return uri.replace(queryParameters: params).toString();
  }
}
