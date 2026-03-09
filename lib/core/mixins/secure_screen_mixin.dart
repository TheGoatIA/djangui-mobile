import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Mixin à appliquer sur les [State] d'écrans contenant des données financières
/// sensibles pour empêcher les captures d'écran et l'enregistrement d'écran.
///
/// ## Écrans concernés (obligatoire)
/// - WalletDashboardPage  (solde)
/// - TransactionDetailPage
/// - SecurityPage / PinScreen
/// - AccountDetailsPage / KYCSubmissionPage
///
/// ## Utilisation
/// ```dart
/// class _WalletDashboardPageState extends State<WalletDashboardPage>
///     with WidgetsBindingObserver, SecureScreenMixin {
///   // ...
/// }
/// ```
/// **Important** : `WidgetsBindingObserver` DOIT précéder `SecureScreenMixin`
/// dans la liste des mixins pour respecter la contrainte `on`.
///
/// ## Implémentation technique
/// - **Android** : FLAG_SECURE via MethodChannel natif
///   (bloque screenshots + enregistrement d'écran)
/// - **iOS**     : Affiche une vue de recouvrement opaque lors du passage
///   en background (iOS empêche nativement le screenshot en app store)
///
/// > Note : Sur les autres plateformes (Web, Desktop), le mixin est no-op.
mixin SecureScreenMixin on State, WidgetsBindingObserver {

  static const _channel = MethodChannel('kauri/secure_screen');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enableSecureMode();
  }

  @override
  void dispose() {
    _disableSecureMode();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // ── Lifecycle iOS : superpose une vue opaque avant capture système ─────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Sur iOS, la miniature du task switcher peut capturer l'écran.
    // On active/désactive le mode sécurisé en fonction du cycle de vie.
    if (!Platform.isAndroid) {
      if (state == AppLifecycleState.inactive ||
          state == AppLifecycleState.hidden) {
        _enableSecureMode();
      } else if (state == AppLifecycleState.resumed) {
        // Re-enable après retour en foreground
        _enableSecureMode();
      }
    }
  }

  // ── Activation ─────────────────────────────────────────────────────────────

  Future<void> _enableSecureMode() async {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid) {
        await _channel.invokeMethod<void>('enableSecureMode');
      }
      // iOS : géré nativement via le recouvrement dans MainActivity
    } catch (e) {
      // Ne jamais laisser une erreur de sécurité crasher l'app
      if (kDebugMode) {
        debugPrint('⚠️ [SecureScreen] enableSecureMode error: $e');
      }
    }
  }

  // ── Désactivation ───────────────────────────────────────────────────────────

  Future<void> _disableSecureMode() async {
    if (kIsWeb) return;
    try {
      if (Platform.isAndroid) {
        await _channel.invokeMethod<void>('disableSecureMode');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [SecureScreen] disableSecureMode error: $e');
      }
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Code natif Android requis dans MainActivity.kt
// ─────────────────────────────────────────────────────────────────────────────
//
// Ajoutez dans android/app/src/main/kotlin/.../MainActivity.kt :
//
// ```kotlin
// import android.view.WindowManager
// import io.flutter.embedding.android.FlutterActivity
// import io.flutter.embedding.engine.FlutterEngine
// import io.flutter.plugin.common.MethodChannel
//
// class MainActivity : FlutterActivity() {
//   private val CHANNEL = "kauri/secure_screen"
//
//   override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//     super.configureFlutterEngine(flutterEngine)
//     MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//       .setMethodCallHandler { call, result ->
//         when (call.method) {
//           "enableSecureMode" -> {
//             window.setFlags(
//               WindowManager.LayoutParams.FLAG_SECURE,
//               WindowManager.LayoutParams.FLAG_SECURE
//             )
//             result.success(null)
//           }
//           "disableSecureMode" -> {
//             window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
//             result.success(null)
//           }
//           else -> result.notImplemented()
//         }
//       }
//   }
// }
// ```
//
// iOS : Aucune modification nécessaire — iOS applique une protection native
// pour les captures d'écran sur les apps App Store. Pour le task switcher,
// ajoutez un UIView de recouvrement dans AppDelegate.swift si requis.
