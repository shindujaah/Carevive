import 'package:carevive/screens/home/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationLogic {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails(String title, String body) async {

    return NotificationDetails(
      android: AndroidNotificationDetails(title, body,
          importance: Importance.max, priority: Priority.max),
    );
  }

  static Future init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings('time_workout');
    final settings = InitializationSettings(android: android);
    await _notifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      onNotifications.add(payload as String?);
    });
  }

  static Future showNotification({
    int? id,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,
  }) async {
    _notifications.zonedSchedule(
      id!,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      await _notificationDetails(title!, body!),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
