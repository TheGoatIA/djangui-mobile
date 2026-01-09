import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../di/injection.dart';

@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Local Notifications Setup
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );
    await _localNotifications.initialize(initializationSettings);

    // Firebase Messaging Setup
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        showLocalNotification(
          id: message.hashCode,
          title: message.notification!.title ?? 'Djangui',
          body: message.notification!.body ?? '',
        );
      }
    });
  }

  Future<void> syncFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        final authRepo = getIt<AuthRepository>();
        // Check if user is logged in before syncing
        if (await authRepo.isAuthenticated()) {
          debugPrint('🔔 [NotificationService] Syncing FCM token: $token');
          await authRepo.updateFcmToken(token);
        }
      }
    } catch (e) {
      debugPrint('🔔 [NotificationService] Failed to sync FCM token: $e');
    }
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'djangui_channel',
          'Djangui Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details);
  }
}
