import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sport_events/core/service/notifications.service.dart';

class FirebaseService {
  static String? fcmToken;

  final FirebaseMessaging fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await NotificationService.initialize();
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('foreground message!');

      await NotificationService().showNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('app open');
      await NotificationService().showNotification(
        title: message.notification!.title!,
        body: message.notification!.body!,
      );
    });
  }
}
