import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:programador/helpers/db.dart';

// Instancia del package
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// Este es el método que inicializa el objeto de notificaciones
Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

// Este es el método que muestra la notificación
Future<void> showNotificacion({dataNotificacion}) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
  );

  try {
    dynamic currentMeetings = await DB.currentMeetings();
    int count = currentMeetings.length;
    if (count > 0) {
      await flutterLocalNotificationsPlugin.show(1, 'Jehova Reina',
          'La iglesia tiene $count actividades hoy.', notificationDetails);
    }
  } catch (e) {
    print(e);
  }
}
