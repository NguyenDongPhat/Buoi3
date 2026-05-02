import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

enum WeatherState { initial, loading, loaded, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;
  final ConnectivityService _connectivityService;
  
  WeatherModel? _currentWeather;
  List<ForecastModel> _forecast = [];
  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';
  bool _isConnected = true;
  String _temperatureUnit = 'Celsius';
  String _windSpeedUnit = 'm/s';
  List<String> _favoriteCities = [];
  List<String> _searchHistory = [];
  
  WeatherProvider(
    this._weatherService,
    this._locationService,
    this._storageService,
    this._connectivityService,
  );
  
  // Getters
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get forecast => _forecast;
  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;
  List<String> get favoriteCities => _favoriteCities;
  List<String> get searchHistory => _searchHistory;
  String get temperatureUnit => _temperatureUnit;
  String get windSpeedUnit => _windSpeedUnit;
  
  Future<void> initialize() async {
    _favoriteCities = await _storageService.getFavoriteCities();
    _searchHistory = await _storageService.getSearchHistory();
    _isConnected = await _connectivityService.isConnected();
    // Load unit preferences
      _temperatureUnit = await _storageService.getTemperatureUnit();
      _windSpeedUnit = await _storageService.getWindSpeedUnit();
    notifyListeners();
  }
  
  // Fetch weather by city
  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();
    
    _isConnected = await _connectivityService.isConnected();

    if (!_isConnected) {
      _errorMessage = 'No internet connection. Showing cached weather if available.';
      await loadCachedWeather();
      if (_currentWeather == null) {
        _state = WeatherState.error;
      }
      notifyListeners();
      return;
    }

    try {
        final units = _temperatureUnit == 'Fahrenheit' ? 'imperial' : 'metric';
        _currentWeather = await _weatherService.getCurrentWeatherByCity(cityName, units: units);
        _forecast = await _weatherService.getForecast(cityName, units: units);
      await _storageService.saveWeatherData(_currentWeather!);
      await _addSearchHistory(cityName);
      
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  // Fetch weather by current location
  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();
    
    _isConnected = await _connectivityService.isConnected();
    if (!_isConnected) {
      _errorMessage = 'No internet connection. Showing cached weather if available.';
      await loadCachedWeather();
      if (_currentWeather == null) {
        _state = WeatherState.error;
      }
      notifyListeners();
      return;
    }

    try {
      final position = await _locationService.getCurrentLocation();
        final units = _temperatureUnit == 'Fahrenheit' ? 'imperial' : 'metric';
        _currentWeather = await _weatherService.getCurrentWeatherByCoordinates(
          position.latitude,
          position.longitude,
          units: units,
        );
      
      String cityName;
      try {
        cityName = await _locationService.getCityName(
          position.latitude,
          position.longitude,
        );
      } catch (_) {
        cityName = _currentWeather?.cityName ?? 'Ho Chi Minh';
      }
      
        _forecast = await _weatherService.getForecast(cityName, units: units);
      await _storageService.saveWeatherData(_currentWeather!);
      await _addSearchHistory(cityName);
      
      _state = WeatherState.loaded;
      _errorMessage = '';
    } catch (e) {
      if (e.toString().contains('Location permission denied')) {
        await fetchWeatherByCity('Ho Chi Minh');
        return;
      }
      if (e.toString().contains('Failed to get city name')) {
        await fetchWeatherByCity(_currentWeather?.cityName ?? 'Ho Chi Minh');
        return;
      }

      _state = WeatherState.error;
      _errorMessage = e.toString();
      
      // Try to load cached data
      await loadCachedWeather();
    }
    
    notifyListeners();
  }
  
  // Load cached weather
  Future<void> loadCachedWeather() async {
    final cachedWeather = await _storageService.getCachedWeather();
    if (cachedWeather != null) {
      _currentWeather = cachedWeather;
      _state = WeatherState.loaded;
      notifyListeners();
    }
  }
  
  // Refresh weather data
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      await fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      await fetchWeatherByLocation();
    }
  }
  
  Future<void> _addSearchHistory(String city) async {
    if (!_searchHistory.contains(city)) {
      _searchHistory.insert(0, city);
      if (_searchHistory.length > 5) {
        _searchHistory.removeLast();
      }
      await _storageService.saveSearchHistory(_searchHistory);
      notifyListeners();
    }
  }
  
  Future<void> addFavoriteCity(String city) async {
    if (!_favoriteCities.contains(city)) {
      _favoriteCities.add(city);
      await _storageService.saveFavoriteCities(_favoriteCities);
      notifyListeners();
    }
  }
  
  Future<void> removeFavoriteCity(String city) async {
    if (_favoriteCities.contains(city)) {
      _favoriteCities.remove(city);
      await _storageService.saveFavoriteCities(_favoriteCities);
      notifyListeners();
    }
  }
}
