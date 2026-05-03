import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

class WeatherService {
  WeatherService();
  
  Future<WeatherModel> getCurrentWeatherByCity(String cityName, {String? units}) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {
          'q': cityName,
          if (units != null) 'units': units,
        },
      );
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  Future<WeatherModel> getCurrentWeatherByCoordinates(
    double lat,
    double lon,
    {String? units}
  ) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.currentWeather,
        {
          'lat': lat.toString(),
          'lon': lon.toString(),
          if (units != null) 'units': units,
        },
      );
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  Future<List<ForecastModel>> getForecast(String cityName, {String? units}) async {
    try {
      final url = ApiConfig.buildUrl(
        ApiConfig.forecast,
        {
          'q': cityName,
          if (units != null) 'units': units,
        },
      );
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'];
        
        return forecastList
            .map((item) => ForecastModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
  
  String getIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }
}
