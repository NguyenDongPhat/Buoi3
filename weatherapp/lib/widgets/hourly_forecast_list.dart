import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/forecast_model.dart';
import '../providers/weather_provider.dart';

class HourlyForecastList extends StatelessWidget {
  final List<ForecastModel> forecasts;
  
  const HourlyForecastList({required this.forecasts});
  
  @override
  Widget build(BuildContext context) {
    if (forecasts.isEmpty) {
      return SizedBox.shrink();
    }
    
    // Filter to show 24 hours
    final hourlyForecasts = forecasts.take(8).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Hourly Forecast',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: hourlyForecasts.map((forecast) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('HH:mm').format(forecast.dateTime),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    CachedNetworkImage(
                      imageUrl: 'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
                      height: 40,
                      errorWidget: (context, url, error) => Icon(Icons.cloud, size: 40),
                    ),
                    SizedBox(height: 8),
                    Builder(builder: (context) {
                      final provider = Provider.of<WeatherProvider>(context);
                      final tempSuffix = provider.temperatureUnit == 'Fahrenheit' ? '°F' : '°C';
                      return Text(
                        '${forecast.temperature.round()}$tempSuffix',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      );
                    }),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
