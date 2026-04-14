# Conformité Vie Privée — Kauri Financial App

> **Référence légale** : RGPD (UE) · NDPR (Nigeria) · Loi camerounaise sur les données personnelles (Loi n° 2010/012)

---

## 1. Données Collectées par les Analytics Mobile

### 1.1 Événements Firebase / OpenTelemetry

Les événements analytics ne contiennent **jamais** de données personnelles identifiables. Le tableau ci-dessous liste les données effectivement transmises.

| Catégorie | Données transmises | Données exclues | Base légale |
|-----------|-------------------|-----------------|-------------|
| Navigation | nom d'écran, durée, version app, type OS | - | Intérêt légitime |
| Authentification | méthode (pin/bio), succès/échec, durée | numéro de téléphone, email | Exécution du contrat |
| Transactions | tranche de montant, méthode paiement, durée | montant exact, nom bénéficiaire, numéro compte | Exécution du contrat |
| Erreurs | type d'erreur, endpoint (sans paramètres), code HTTP | données personnelles dans les paramètres | Intérêt légitime |
| Profil utilisateur | `user_id` hashé SHA-256 | ID brut, email, téléphone | Consentement |

### 1.2 Données Firebase Crashlytics

En cas de crash, Crashlytics reçoit :

| Clé | Valeur transmise | Note |
|-----|-----------------|------|
| `user_id_hash` | SHA-256 de l'ID utilisateur | Jamais l'ID brut |
| `screen_name` | Nom de l'écran (ex: `wallet_dashboard`) | - |
| `last_action` | Dernière action (ex: `send_money_confirmed`) | - |
| `app_state` | `foreground` ou `background` | - |
| `network_state` | `wifi`, `4g`, `offline` | Jamais l'IP |
| `wallet_state` | `loaded`, `loading`, `error` | **Jamais le solde** |
| `last_bloc_state` | Type du dernier état BLoC | - |

### 1.3 Données OpenTelemetry (Grafana)

Envoyées vers l'infrastructure interne Kauri uniquement. Contiennent :
- Spans de performance (durée des opérations)
- Compteurs de navigation (fréquence d'écrans)
- Métriques d'erreurs API (endpoints sans paramètres sensibles)

---

## 2. Règles d'Anonymisation (implémentées dans le code)

### 2.1 Montants — Jamais de valeurs exactes

```dart
// ✅ CORRECT — utiliser AnalyticsAmountRange
final range = AnalyticsAmountRange.fromAmount(transaction.amount);
analyticsService.logEvent('send_money_completed', parameters: {
  'amount_range': range,  // ex: '1001-10000'
});

// ❌ INTERDIT
analyticsService.logEvent('send_money_completed', parameters: {
  'amount': transaction.amount,  // JAMAIS !
});
```

### 2.2 User ID — Toujours hashé

```dart
// ✅ CORRECT — via AnalyticsService.setUserId()
await analyticsService.setUserId(user.id);
// → Hashé automatiquement en SHA-256 avant tout envoi

// ❌ INTERDIT
analyticsService.logEvent('login', parameters: {
  'user_id': user.id,      // JAMAIS !
  'email': user.email,     // JAMAIS !
  'phone': user.phone,     // JAMAIS !
});
```

### 2.3 Filtre automatique des clés sensibles

Le service `KauriAnalyticsService` filtre automatiquement les clés suivantes :

```dart
static const _sensitiveKeys = {
  'amount', 'balance', 'account_number', 'phone', 'phone_number',
  'name', 'email', 'iban', 'card_number', 'pin', 'password',
  'token', 'secret',
};
```

Si une de ces clés est passée par erreur, elle est silencieusement supprimée.

---

## 3. Consentement Utilisateur

### 3.1 Collecte lors de l'onboarding

- L'utilisateur est informé de la collecte de données analytics lors de l'onboarding (étape dédiée)
- Le consentement est stocké localement (`flutter_secure_storage`)
- Base légale : **Consentement explicite** (Art. 6(1)(a) RGPD)

### 3.2 Opt-out

- Option de désactivation des analytics accessible dans **Paramètres > Confidentialité**
- En cas d'opt-out : `AnalyticsService.logEvent()` est intercepté et ne transmet rien
- Le retrait du consentement est effectif immédiatement

---

## 4. Rétention des Données

| Système | Durée de rétention | Suppression |
|---------|-------------------|-------------|
| Firebase Crashlytics | 90 jours | Automatique |
| OpenTelemetry / Grafana | 30 jours (spans) | Configurable |
| Backend Analytics Kauri | 12 mois | Sur demande |
| Logs Graylog | 30 jours | Automatique |

---

## 5. Droits des Utilisateurs (RGPD Art. 15-22)

| Droit | Mécanisme |
|-------|-----------|
| **Accès** | Export disponible via l'API Kauri (endpoint `/user/data-export`) |
| **Rectification** | Via l'interface de profil utilisateur |
| **Effacement** | Compte supprimable via l'app ou par email DPO |
| **Portabilité** | Export JSON/CSV disponible |
| **Opposition** | Opt-out analytics dans les paramètres |
| **Limitation** | Compte peut être suspendu sans suppression |

Contact DPO : **privacy@kauri.cm** (ou l'email configuré dans l'app)

---

## 6. Transferts Internationaux de Données

| Destination | Données | Garanties |
|-------------|---------|-----------|
| Firebase (Google) | Crashlytics, Performance | Clauses contractuelles types (CCT) |
| Grafana Cloud (si utilisé) | Métriques de performance | Accord de traitement des données |
| Infrastructure Kauri (Cameroun/Afrique) | Logs, Analytics backend | Données stockées localement |

---

## 7. Données Exclues des Analytics (liste exhaustive)

```
❌ Montants exacts de transactions ou de solde
❌ Numéros de téléphone (expéditeur ou destinataire)
❌ Numéros de compte, IBAN, numéros de carte
❌ Noms d'utilisateurs ou de bénéficiaires
❌ Adresses email
❌ Code PIN ou mots de passe (même hashés)
❌ Tokens d'authentification
❌ Coordonnées GPS précises
❌ Contenu textuel des recherches
❌ Numéros de documents d'identité (CNI, passeport)
❌ Photos ou captures d'écran
❌ Contacts téléphoniques individuels (seul le compte total est transmis)
```

---

## 8. Audit & Responsabilité

- **Responsable du traitement** : Kauri / TBG CM
- **DPO** : privacy@kauri.cm
- **Dernière révision** : 2026-03-09
- **Prochaine révision** : 2026-09-09

### 8.1 Processus de validation

Avant chaque release majeure :
1. Vérifier que `AnalyticsService._sanitize()` couvre toutes les nouvelles clés sensibles
2. Auditer les nouveaux événements ajoutés pour s'assurer qu'ils respectent les règles ci-dessus
3. Tester en mode debug que `debugPrint` ne logue pas de données sensibles
4. Mettre à jour ce document si de nouveaux types de données sont collectés

---

*Ce document est à maintenir à jour à chaque modification du comportement de collecte de données.*
