import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../di/injection.dart';
import '../../routes/app_router.dart';
import '../constants/route_constants.dart';
import 'log_service.dart';

/// Service gérant les notifications push (Firebase Messaging) et locales.
///
/// Ce service centralise l'initialisation, la demande de permissions,
/// l'écoute des messages en arrière-plan et l'affichage des alertes locales.
@lazySingleton
class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialise les configurations pour Android et iOS.
  /// Configure également l'écoute des messages Firebase en premier plan.
  Future<void> initialize() async {
    // Configuration pour Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');

    // Configuration pour iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onLocalNotificationTapped,
    );

    // Configuration de Firebase Messaging
    final FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Demande des permissions utilisateur (obligatoire sur iOS et Android 13+).
    // NON bloquante : `initialize()` s'exécute avant `runApp()` ; attendre la
    // réponse gelait le démarrage (écran vide derrière la fenêtre système)
    // tant que l'utilisateur n'avait pas répondu — constaté en E2E (≈ 11 min
    // de blocage sur émulateur). L'interface s'affiche, la réponse arrive après.
    unawaited(
      messaging
          .requestPermission(alert: true, badge: true, sound: true)
          .then<void>((_) {})
          .catchError((Object e) {
            getIt<LogService>().warning(
              'Demande de permission notifications échouée: $e',
              component: 'NotificationService',
            );
          }),
    );

    // Écoute des messages reçus pendant que l'application est ouverte (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      getIt<LogService>().info(
        'Notification FCM reçue au premier plan',
        component: 'NotificationService',
        metadata: {'data': message.data, 'messageId': message.messageId},
      );

      // Traitement des notifications de données (silencieuses) pour rafraîchir l'interface
      final type = message.data['type'];
      if (type == 'country_change_approved' || type == 'profile_update') {
        getIt<AuthBloc>().add(AuthRefreshUserRequested());
      }

      // Si le message contient une notification visuelle, on l'affiche localement
      if (message.notification != null) {
        showLocalNotification(
          id: message.hashCode,
          title: message.notification!.title ?? 'Kauri',
          body: message.notification!.body ?? '',
          data: message.data,
        );
      }
    });

    // Firebase peut faire tourner le jeton FCM en cours de session (réinstallation,
    // expiration, changement d'appareil restauré...). Sans cet écouteur, le backend
    // garde l'ancien jeton et les notifications push s'arrêtent silencieusement.
    FirebaseMessaging.instance.onTokenRefresh.listen((_) {
      syncFcmToken();
    });

    // Tap sur une notification alors que l'app était en arrière-plan (pas tuée).
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Tap sur une notification ayant lancé l'app depuis un état tué (cold start).
    // Différé au frame suivant : le routeur (appRouter) doit être monté avant
    // qu'on puisse naviguer, ce qui n'est pas encore le cas à cet instant précis
    // (cet `initialize()` s'exécute avant `runApp()`).
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationTap(initialMessage);
      });
    }
  }

  /// Tap sur une notification FCM (app en arrière-plan ou lancée depuis l'état tué).
  void _handleNotificationTap(RemoteMessage message) {
    getIt<LogService>().info(
      'Notification ouverte par l\'utilisateur (FCM)',
      component: 'NotificationService',
      metadata: {'data': message.data},
    );
    _navigateForNotificationData(message.data);
  }

  /// Tap sur une notification locale (affichée pendant que l'app était au premier plan).
  void _onLocalNotificationTapped(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      final data = decoded.map((key, value) => MapEntry(key, value.toString()));
      getIt<LogService>().info(
        'Notification ouverte par l\'utilisateur (locale)',
        component: 'NotificationService',
        metadata: {'data': data},
      );
      _navigateForNotificationData(data);
    } catch (e) {
      getIt<LogService>().error(
        'Échec de décodage du payload de notification locale',
        component: 'NotificationService',
        error: e,
      );
    }
  }

  /// Navigue vers l'écran concerné par une notification, à partir de son `data`.
  /// Seules les notifications de tontine (`type` préfixé `TONTINE_`) portent
  /// aujourd'hui un `tontineId` exploitable pour un deep-link.
  void _navigateForNotificationData(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    final tontineId = data['tontineId']?.toString();
    if (type == null || tontineId == null || !type.startsWith('TONTINE_')) {
      return;
    }

    appRouter.goNamed(
      RouteConstants.tontineDetailsNamed,
      pathParameters: {'id': tontineId},
      extra: type == 'TONTINE_NEW_MESSAGE' ? {'initialTabIndex': 2} : null,
    );
  }

  /// Récupère le jeton FCM de l'appareil et le synchronise avec le serveur backend.
  /// Cette synchronisation n'est effectuée que si l'utilisateur est authentifié.
  Future<void> syncFcmToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        final authRepo = getIt<AuthRepository>();
        if (await authRepo.isAuthenticated()) {
          getIt<LogService>().info(
            'Synchronisation du jeton FCM',
            component: 'NotificationService',
            metadata: {'token_prefix': token.substring(0, 5)},
          );
          await authRepo.updateFcmToken(token);
        }
      }
    } catch (e) {
      getIt<LogService>().error(
        'Échec de synchronisation du jeton FCM',
        component: 'NotificationService',
        error: e,
      );
    }
  }

  /// Affiche une notification système locale (utile pour le Foreground sur Android).
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'Kauri_channel',
          'Kauri Notifications',
          importance: Importance.max,
          priority: Priority.high,
          icon: 'ic_notification',
          color: Color(0xFF10B981),
        );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      details,
      payload: data != null ? jsonEncode(data) : null,
    );
    getIt<LogService>().info(
      'Notification locale affichée',
      component: 'NotificationService',
      metadata: {'title': title, 'body': body},
    );
  }
}
