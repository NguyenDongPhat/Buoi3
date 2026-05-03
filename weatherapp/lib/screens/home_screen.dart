import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/weather_detail_item.dart';
import '../utils/date_formatter.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = context.read<WeatherProvider>();
      await provider.initialize();
      await provider.fetchWeatherByLocation();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<WeatherProvider>().refreshWeather(),
        child: Consumer<WeatherProvider>(
          builder: (context, provider, child) {
            String formatWind(double speed) {
              final baseUnit = provider.temperatureUnit == 'Fahrenheit' ? 'mph' : 'm/s';
              final target = provider.windSpeedUnit;
              double value = speed;
              if (baseUnit == 'm/s') {
                if (target == 'km/h') value = speed * 3.6;
                if (target == 'mph') value = speed * 2.23694;
              } else {
                if (target == 'km/h') value = speed * 1.60934;
                if (target == 'm/s') value = speed * 0.44704;
              }
              return '${value.toStringAsFixed(1)} $target';
            }

            if (provider.state == WeatherState.loading) {
              return LoadingShimmer();
            }
            
            if (provider.state == WeatherState.error) {
              return ErrorWidgetCustom(
                message: provider.errorMessage,
                onRetry: () => provider.fetchWeatherByLocation(),
              );
            }
            
            if (provider.currentWeather == null) {
              return Center(child: Text('No weather data'));
            }
            
            return SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  if (!provider.isConnected)
                    Container(
                      width: double.infinity,
                      color: Colors.orange.shade100,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Text(
                        'No internet connection. Showing cached data if available.',
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  CurrentWeatherCard(weather: provider.currentWeather!),
                  HourlyForecastList(forecasts: provider.forecast),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      '5-Day Forecast',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...provider.forecast
                      .where((f) {
                        final now = DateTime.now();
                        return f.dateTime.day > now.day ||
                            (f.dateTime.day == now.day && f.dateTime.hour > now.add(Duration(hours: 24)).hour);
                      })
                      .take(5)
                      .map((forecast) => DailyForecastCard(forecast: forecast))
                      .toList(),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Weather Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      WeatherDetailItem(
                        icon: Icons.opacity,
                        label: 'Humidity',
                        value: '${provider.currentWeather!.humidity}%',
                      ),
                      WeatherDetailItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                          value: formatWind(provider.currentWeather!.windSpeed),
                      ),
                      WeatherDetailItem(
                        icon: Icons.compress,
                        label: 'Pressure',
                        value: '${provider.currentWeather!.pressure} mb',
                      ),
                      WeatherDetailItem(
                        icon: Icons.visibility,
                        label: 'Visibility',
                        value: '${(provider.currentWeather!.visibility ?? 0) / 1000} km',
                      ),
                      WeatherDetailItem(
                        icon: Icons.cloud,
                        label: 'Cloudiness',
                        value: '${provider.currentWeather!.cloudiness ?? 0}%',
                      ),
                      WeatherDetailItem(
                        icon: Icons.wb_sunny_outlined,
                        label: 'Sunrise',
                        value: DateFormatter.formatTime(
                          provider.currentWeather!.sunrise,
                          use24hFormat: provider.timeFormat == '24h',
                        ),
                      ),
                      WeatherDetailItem(
                        icon: Icons.nightlight_round,
                        label: 'Sunset',
                        value: DateFormatter.formatTime(provider.currentWeather!.sunset),
                      ),
                      WeatherDetailItem(
                        icon: Icons.thermostat,
                        label: 'Feels Like',
                        value: '${provider.currentWeather!.feelsLike.round()}${provider.temperatureUnit == 'Fahrenheit' ? '°F' : '°C'}',
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
