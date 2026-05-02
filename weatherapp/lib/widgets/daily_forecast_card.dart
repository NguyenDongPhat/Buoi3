import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/forecast_model.dart';
import '../providers/weather_provider.dart';

class DailyForecastCard extends StatelessWidget {
  final ForecastModel forecast;
  
  const DailyForecastCard({required this.forecast});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: 'https://openweathermap.org/img/wn/${forecast.icon}@2x.png',
              height: 50,
              errorWidget: (context, url, error) => Icon(Icons.cloud, size: 50),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('EEE, MMM d').format(forecast.dateTime),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 4),
                  Text(
                    forecast.description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(builder: (context) {
                  final provider = Provider.of<WeatherProvider>(context);
                  final tempSuffix = provider.temperatureUnit == 'Fahrenheit' ? '°F' : '°C';
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${forecast.tempMax.round()}$tempSuffix',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '${forecast.tempMin.round()}$tempSuffix',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
