import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _temperatureUnit = 'Celsius';
  String _windSpeedUnit = 'm/s';
  String _timeFormat = '24h';
  final StorageService _storage = StorageService();
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final temp = await _storage.getTemperatureUnit();
    final wind = await _storage.getWindSpeedUnit();
    final time = await _storage.getTimeFormat();
    setState(() {
      _temperatureUnit = temp;
      _windSpeedUnit = wind;
      _timeFormat = time;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Units & Format',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Temperature Unit'),
              subtitle: Text(_temperatureUnit),
              trailing: DropdownButton<String>(
                value: _temperatureUnit,
                items: ['Celsius', 'Fahrenheit'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  final val = newValue ?? 'Celsius';
                  await _storage.saveTemperatureUnit(val);
                  setState(() {
                    _temperatureUnit = val;
                  });
                  // Notify provider to reload preferences
                  try {
                    final provider = Provider.of<WeatherProvider>(context, listen: false);
                    await provider.initialize();
                  } catch (_) {}
                },
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Wind Speed Unit'),
              subtitle: Text(_windSpeedUnit),
              trailing: DropdownButton<String>(
                value: _windSpeedUnit,
                items: ['m/s', 'km/h', 'mph'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  final val = newValue ?? 'm/s';
                  await _storage.saveWindSpeedUnit(val);
                  setState(() {
                    _windSpeedUnit = val;
                  });
                  try {
                    final provider = Provider.of<WeatherProvider>(context, listen: false);
                    await provider.initialize();
                  } catch (_) {}
                },
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Time Format'),
              subtitle: Text(_timeFormat),
              trailing: DropdownButton<String>(
                value: _timeFormat,
                items: ['12h', '24h'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) async {
                  final val = newValue ?? '24h';
                  await _storage.saveTimeFormat(val);
                  setState(() {
                    _timeFormat = val;
                  });
                  try {
                    final provider = Provider.of<WeatherProvider>(context, listen: false);
                    await provider.initialize();
                  } catch (_) {}
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'About',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('App Version'),
              subtitle: Text('1.0.0'),
            ),
          ),
          Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Weather API'),
              subtitle: Text('OpenWeatherMap'),
            ),
          ),
        ],
      ),
    );
  }
}
