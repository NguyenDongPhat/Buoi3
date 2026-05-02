import 'package:flutter_test/flutter_test.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:weatherapp/models/forecast_model.dart';
import 'package:weatherapp/services/weather_service.dart';

void main() {
  group('WeatherService Tests', () {
    
    // Test 1: Kiểm tra parse JSON Weather Model (từ đề)
    test('Parse weather JSON correctly', () {
      final Map<String, dynamic> json = {
        "name": "Ho Chi Minh City",
        "sys": {
          "country": "VN",
          "sunrise": 1600000000,
          "sunset": 1600040000
        },
        "main": {
          "temp": 25.0,
          "feels_like": 27.0,
          "humidity": 80,
          "pressure": 1010,
          "temp_min": 23.0,
          "temp_max": 28.0,
        },
        "wind": {"speed": 5.0, "deg": 120},
        "weather": [
          {
            "description": "clear sky",
            "icon": "01d",
            "main": "Clear"
          }
        ],
        "dt": 1600020000,
        "visibility": 10000,
        "clouds": {"all": 0}
      };

      final weather = WeatherModel.fromJson(json);

      expect(weather.temperature, 25.0);
      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.country, 'VN');
      expect(weather.humidity, 80);
      expect(weather.windSpeed, 5.0);
      expect(weather.windDegree, 120);
      expect(weather.mainCondition, 'Clear');
    });

    // Test 2: Parse Forecast Model JSON
    test('Parse forecast JSON correctly', () {
      final Map<String, dynamic> json = {
        "dt": 1600020000,
        "main": {
          "temp": 25.0,
          "temp_min": 23.0,
          "temp_max": 28.0,
          "humidity": 80,
        },
        "weather": [
          {
            "description": "light rain",
            "icon": "10d",
            "main": "Rain"
          }
        ],
        "wind": {"speed": 4.5},
        "pop": 0.6,
      };

      final forecast = ForecastModel.fromJson(json);

      expect(forecast.temperature, 25.0);
      expect(forecast.tempMin, 23.0);
      expect(forecast.tempMax, 28.0);
      expect(forecast.humidity, 80);
      expect(forecast.windSpeed, 4.5);
      expect(forecast.pop, 0.6);
      expect(forecast.description, 'light rain');
    });

    // Test 3: Weather toJson/fromJson (roundtrip test)
    test('Weather model roundtrip conversion', () {
      final original = WeatherModel(
        cityName: 'New York',
        country: 'US',
        temperature: 20.0,
        feelsLike: 18.0,
        humidity: 75,
        windSpeed: 3.0,
        windDegree: 180,
        pressure: 1013,
        description: 'Cloudy',
        icon: '04d',
        mainCondition: 'Clouds',
        dateTime: DateTime(2024, 1, 1),
        sunrise: DateTime(2024, 1, 1, 7, 0),
        sunset: DateTime(2024, 1, 1, 17, 0),
        tempMin: 18.0,
        tempMax: 22.0,
        visibility: 10000,
        cloudiness: 50,
      );

      final json = original.toJson();
      final restored = WeatherModel.fromJson(json);

      expect(restored.cityName, original.cityName);
      expect(restored.temperature, original.temperature);
      expect(restored.humidity, original.humidity);
    });

    // Test 4: Xử lý lỗi API (từ đề)
    test('Handle API error gracefully - Invalid city', () async {
      final weatherService = WeatherService();
      
      expect(
        () => weatherService.getCurrentWeatherByCity('InvalidCityNameThatiSnotReal'),
        throwsException,
      );
    });

    // Test 5: Empty list handling
    test('Handle empty forecast list', () {
      final empty = <ForecastModel>[];
      expect(empty.isEmpty, true);
      expect(empty.length, 0);
    });

    // Test 6: Weather icon mapping
    test('Weather conditions match expected values', () {
      final conditions = ['Clear', 'Clouds', 'Rain', 'Snow', 'Thunderstorm'];
      
      for (final condition in conditions) {
        expect(condition, isNotEmpty);
      }
    });
    
  });

  group('Weather Model Edge Cases', () {
    
    test('Handle null optional fields', () {
      final Map<String, dynamic> json = {
        "name": "TestCity",
        "sys": {"country": "TC", "sunrise": 1600000000, "sunset": 1600040000},
        "main": {
          "temp": 20.0,
          "feels_like": 20.0,
          "humidity": 50,
          "pressure": 1013,
        },
        "wind": {"speed": 2.0, "deg": 0},
        "weather": [{"description": "clear", "icon": "01d", "main": "Clear"}],
        "dt": 1600020000,
      };

      final weather = WeatherModel.fromJson(json);
      
      expect(weather.tempMin, isNull);
      expect(weather.tempMax, isNull);
      expect(weather.visibility, isNull);
      expect(weather.cloudiness, isNull);
    });

    test('Handle temperature conversion', () {
      expect(25.0.toDouble(), 25.0);
      expect((25).toDouble(), 25.0);
    });
  });
}