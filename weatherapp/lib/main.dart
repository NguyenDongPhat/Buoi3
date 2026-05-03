import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherapp/providers/weather_provider.dart';
import 'package:weatherapp/providers/location_provider.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:weatherapp/services/location_service.dart';
import 'package:weatherapp/services/storage_service.dart';
import 'package:weatherapp/services/connectivity_service.dart';
import 'package:weatherapp/services/notification_service.dart';
import 'package:weatherapp/screens/home_screen.dart';
import 'package:weatherapp/config/api_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.requestPermission();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    try {
      await dotenv.load();
    } catch (e2) {
    }
  }
  
  final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  ApiConfig.setApiKey(apiKey);
  
  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final NotificationService notificationService;
  
  const MyApp({Key? key, required this.notificationService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherService>(
          create: (_) => WeatherService(),
        ),
        Provider<LocationService>(
          create: (_) => LocationService(),
        ),
        Provider<StorageService>(
          create: (_) => StorageService(),    
        ),
        Provider<ConnectivityService>(
          create: (_) => ConnectivityService(),
        ),
        Provider<NotificationService>.value(
          value: notificationService,
        ),
        ChangeNotifierProvider(
          create: (context) => LocationProvider(
            context.read<LocationService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(
            context.read<WeatherService>(),
            context.read<LocationService>(),
            context.read<StorageService>(),
            context.read<ConnectivityService>(),
            context.read<NotificationService>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Weather App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}