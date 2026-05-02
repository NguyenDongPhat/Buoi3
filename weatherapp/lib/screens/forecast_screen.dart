import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/daily_forecast_card.dart';

class ForecastScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('5-Day Forecast'),
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) {
          if (provider.forecast.isEmpty) {
            return Center(child: Text('No forecast data'));
          }
          
          return ListView.builder(
            itemCount: provider.forecast.length,
            itemBuilder: (context, index) {
              return DailyForecastCard(forecast: provider.forecast[index]);
            },
          );
        },
      ),
    );
  }
}
