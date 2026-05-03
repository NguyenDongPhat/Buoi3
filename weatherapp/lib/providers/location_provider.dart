import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../services/location_service.dart';

enum LocationState { initial, loading, loaded, error }

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;
  
  LocationModel? _currentLocation;
  LocationState _state = LocationState.initial;
  String _errorMessage = '';
  
  LocationProvider(this._locationService);
  
  LocationModel? get currentLocation => _currentLocation;
  LocationState get state => _state;
  String get errorMessage => _errorMessage;
  
  Future<void> fetchCurrentLocation() async {
    _state = LocationState.loading;
    notifyListeners();
    
    try {
      final position = await _locationService.getCurrentLocation();
      final cityName = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );
      
      _currentLocation = LocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: cityName,
      );
      
      _state = LocationState.loaded;
      _errorMessage = '';
    } catch (e) {
      _state = LocationState.error;
      _errorMessage = e.toString();
    }
    
    notifyListeners();
  }
  
  Future<bool> checkLocationPermission() async {
    try {
      return await _locationService.checkPermission();
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    }
  }
  
  void resetLocation() {
    _currentLocation = null;
    _state = LocationState.initial;
    _errorMessage = '';
    notifyListeners();
  }
}
