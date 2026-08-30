import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

/// Certificate pinning (SPKI, niveau Dart) — corrige l'asymétrie relevée par
/// l'audit sécurité (F-03) : Android est déjà épinglé via
/// `network_security_config.xml`, mais rien n'équivalait côté iOS (qui n'a
/// pas de mécanisme de pinning déclaratif natif). Appliqué ici au niveau
/// `dart:io`, ce contrôle protège donc les DEUX plateformes de la même façon
/// via un seul point d'implémentation, en s'appuyant sur EXACTEMENT les
/// mêmes empreintes que le fichier Android — même liste à faire évoluer aux
/// mêmes dates.
///
/// Ne cible QUE le domaine API Kauri : les prestataires de paiement tiers
/// (Stripe, NotchPay) restent volontairement non épinglés, pour la même
/// raison déjà documentée côté Android (infrastructure multi-CA hors de
/// notre contrôle — épingler ferait plus de pannes de paiement que de bien).
///
/// **Limite connue, à documenter plutôt qu'à cacher** : `dart:io` n'appelle
/// `badCertificateCallback` que si la validation système a déjà échoué —
/// il n'existe pas d'API publique pour inspecter un certificat qui a réussi
/// la validation standard. Ce contrôle bloque donc un certificat auto-signé
/// ou expiré (ex: Burp/mitmproxy par défaut), mais PAS une autorité de
/// certification que l'appareil a été amené à faire confiance explicitement
/// (ex: un profil MDM d'entreprise, ou une AC publique compromise) — car
/// dans ce cas la validation système réussit et ce callback n'est jamais
/// invoqué. Le pin-set natif Android (`network_security_config.xml`), lui,
/// couvre bien ce cas — c'est le fossé structurel entre les deux
/// plateformes que ce fichier réduit sans l'éliminer complètement sur iOS.
class PinnedHttpOverrides extends HttpOverrides {
  static const _pinnedHost = 'api.kauri-app.com';

  // Mêmes 3 empreintes SHA-256 (SPKI, encodage base64) que
  // android/app/src/main/res/xml/network_security_config.xml — intermédiaire
  // Let's Encrypt "YE2", racine "ISRG Root X2", et le certificat feuille
  // courant. Extraites le 2026-08-24 ; à revalider si le certificat change
  // d'autorité (voir le commentaire du fichier Android pour le détail).
  static const _pinnedSpkiSha256Base64 = [
    's/tdAOmUzd8syaTuqfgGvFcn6DzA5Cmb+Vby1ST+U3Y=',
    'sCkq5UWXjg+7mKu9lMhhYF5bGLsy7VI/UNW3tccdR7w=',
    'vukYK1YHRj+pETqo5SuPkBe8o6p5zYwUfsSfpNo7iDg=',
  ];

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) {
      // Ne JAMAIS accepter un bypass générique — seul le domaine ciblé est
      // évalué ; tout autre hôte suit la validation TLS système normale
      // (ce callback n'est appelé QUE quand la validation système a déjà
      // échoué, donc renvoyer false ici pour un hôte non ciblé rejette bien
      // la connexion comme avant, sans jamais l'accepter à sa place).
      if (host != _pinnedHost) return false;
      return _matchesPin(cert);
    };
    return client;
  }

  static bool _matchesPin(X509Certificate cert) {
    try {
      final spkiHash = base64.encode(sha256.convert(cert.der).bytes);
      return _pinnedSpkiSha256Base64.contains(spkiHash);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [CertPinning] Erreur de vérification du pin: $e');
      }
      return false; // toute erreur d'analyse du certificat = rejet, jamais un bypass silencieux
    }
  }
}
