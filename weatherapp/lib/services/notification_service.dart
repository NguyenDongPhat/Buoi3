import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
      },
    );
  }

  Future<void> requestPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  Future<void> showWeatherNotification({
    required String city,
    required String temp,
    required String desc,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'weather_app_channel_id',
      'Weather Updates',
      channelDescription: 'Nhận thông báo cập nhật thời tiết mới nhất',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      showWhen: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Thời tiết tại $city',
      'Hiện tại: $temp - $desc',
      notificationDetails,
    );
  }
}