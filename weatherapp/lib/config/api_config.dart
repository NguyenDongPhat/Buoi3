class ApiConfig {
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static String? _apiKey;
  
  static const String currentWeather = '/weather';
  static const String forecast = '/forecast';
  static const String oneCall = '/onecall';
  
  static void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }
  
  static String get apiKey => _apiKey ?? '';
  
  static String buildUrl(String endpoint, Map<String, dynamic> params) {
    final uri = Uri.parse('$baseUrl$endpoint');
    params['appid'] = apiKey;
    if (!params.containsKey('units')) {
      params['units'] = 'metric'; 
    }
    return uri.replace(queryParameters: params).toString();
  }
}
