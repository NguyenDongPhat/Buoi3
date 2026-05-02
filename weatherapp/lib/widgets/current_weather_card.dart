import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/weather_model.dart';
import '../providers/weather_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherModel weather;
  
  const CurrentWeatherCard({required this.weather});
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WeatherProvider>(context);
    final tempSuffix = provider.temperatureUnit == 'Fahrenheit' ? '°F' : '°C';
    
    // Kiểm tra xem hiện tại là ngày hay đêm
    bool isNight = weather.dateTime.isAfter(weather.sunset) || 
                   weather.dateTime.isBefore(weather.sunrise);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Truyền thêm isNight vào hàm
        gradient: _getWeatherGradient(weather.mainCondition, isNight), 
      ),
      child: Column(
        children: [
          Text(
            weather.cityName,
            style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            DateFormat('EEEE, MMM d').format(weather.dateTime),
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 20),
          CachedNetworkImage(
            imageUrl: 'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
            height: 120,
            errorWidget: (context, url, error) => Icon(Icons.cloud, size: 120, color: Colors.white),
          ),
          Text(
            '${weather.temperature.round()}$tempSuffix',
            style: TextStyle(fontSize: 80, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            weather.description.toUpperCase(),
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          Text(
            'Feels like ${weather.feelsLike.round()}$tempSuffix',
            style: TextStyle(fontSize: 16, color: Colors.white70),
          ),
          SizedBox(height: 10),
          Text(
            '${weather.country}',
            style: TextStyle(fontSize: 14, color: Colors.white60),
          ),
        ],
      ),
    );
  }
  
  LinearGradient _getWeatherGradient(String condition, bool isNight) {
    // Ưu tiên check ban đêm trước
    if (isNight) {
      return LinearGradient(
        colors: [Color(0xFF2D3748), Color(0xFF1A202C)], // Màu Night theo đề
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }

    // Ban ngày thì check theo thời tiết (Mã màu theo đề tài)
    switch (condition.toLowerCase()) {
      case 'clear':
        return LinearGradient(
          colors: [Color(0xFFFDB813), Color(0xFF87CEEB)], // Màu Sunny theo đề
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'clouds':
        return LinearGradient(
          colors: [Color(0xFFA0AEC0), Color(0xFFCBD5E0)], // Màu Cloudy theo đề
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return LinearGradient(
          colors: [Color(0xFF4A5568), Color(0xFF718096)], // Màu Rainy theo đề
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'snow':
        return LinearGradient(
          colors: [Color(0xFFBCE5F5), Color(0xFFEBF4F7)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF87CEEB)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }
}
