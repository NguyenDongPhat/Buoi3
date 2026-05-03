import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _lastUpdateKey = 'last_update';
  static const String _favoriteCitiesKey = 'favorite_cities';
  static const String _searchHistoryKey = 'search_history'; // Key lưu lịch sử tìm kiếm
  
  // Lưu trữ dữ liệu thời tiết
  Future<void> saveWeatherData(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, json.encode(weather.toJson()));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  // Lấy dữ liệu thời tiết đã lưu (cache)
  Future<WeatherModel?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherJson = prefs.getString(_weatherKey);
    
    if (weatherJson != null) {
      return WeatherModel.fromJson(json.decode(weatherJson));
    }
    return null;
  }
  
  // Kiểm tra thời gian cache (ví dụ: < 30 phút là hợp lệ)
  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final lastUpdate = prefs.getInt(_lastUpdateKey);
    
    if (lastUpdate == null) return false;
    
    final difference = DateTime.now().millisecondsSinceEpoch - lastUpdate;
    return difference < 30 * 60 * 1000;
  }
  
  // LƯU TRỮ VÀ LẤY DANH SÁCH YÊU THÍCH
  Future<void> saveFavoriteCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteCitiesKey, cities);
  }
  
  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  // LƯU TRỮ VÀ LẤY LỊCH SỬ TÌM KIẾM
  // ĐÂY CHÍNH LÀ HÀM BẠN BỊ THIẾU
  Future<void> saveSearchHistory(List<String> history) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  // CÀI ĐẶT NGƯỜI DÙNG (C/F, tốc độ gió, định dạng giờ)
  static const String _temperatureUnitKey = 'temperature_unit';
  static const String _windSpeedUnitKey = 'wind_speed_unit';
  static const String _timeFormatKey = 'time_format';

  Future<void> saveTemperatureUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_temperatureUnitKey, unit);
  }

  Future<String> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_temperatureUnitKey) ?? 'Celsius';
  }

  Future<void> saveWindSpeedUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_windSpeedUnitKey, unit);
  }

  Future<String> getWindSpeedUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_windSpeedUnitKey) ?? 'm/s';
  }

  Future<void> saveTimeFormat(String format) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_timeFormatKey, format);
  }

  Future<String> getTimeFormat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_timeFormatKey) ?? '24h';
  }
}