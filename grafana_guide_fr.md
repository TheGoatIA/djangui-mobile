# 📊 Guide de Configuration Grafana pour Kauri

Ce guide vous accompagne étape par étape pour transformer les données de télémétrie de l'application Kauri en tableaux de bord visuels et exploitables.

## ⚙️ Étape 0 : Pré-requis
1. **Source de données** : Assurez-vous d'avoir ajouté votre source **Prometheus** (pour les métriques) dans Grafana.
2. **Intervalle** : Réglez l'intervalle de rafraîchissement sur "5s" ou "15s" pour voir les données en temps réel pendant vos tests.

---

## 📱 Dashboard 1 : Santé & Performance (Mobile Vitals)
*Objectif : Surveiller la fluidité technique de l'application.*

### 1.1 Temps de Démarrage (Cold Start)
- **Type de Panel** : Stat
- **Requête (PromQL)** : `avg(app_startup_duration_ms)`
- **Configuration** :
    - Unité : `milliseconds (ms)`
    - Seuils : Vert (< 1000ms), Orange (1000-3000ms), Rouge (> 3000ms).

### 1.2 Poids de la Base de Données
- **Type de Panel** : Gauge
- **Requête** : `max(db_size_bytes) / 1024 / 1024`
- **Configuration** :
    - Unité : `Megabytes (MB)`
    - Titre : "Taille SQLite (Mo)"

### 1.3 Latence Moyenne des API
- **Type de Panel** : Time Series
- **Requête** : `rate(http_client_duration_ms_sum[5m]) / rate(http_client_duration_ms_count[5m])`
- **Titre** : "Latence API (Moyenne glissante 5m)"

---

## 🤖 Dashboard 2 : IA & Engagement (Coach Anne)
*Objectif : Mesurer l'utilité et la performance de l'IA.*

### 2.1 Réactivité de l'IA (Anne)
- **Type de Panel** : Bar Gauge
- **Requête** : `avg(ux_ai_coach_response_latency_ms) by (model)`
- **Unité** : `milliseconds (ms)`

### 2.2 Entonnoir (Funnel) du Tutoriel
- **Type de Panel** : Bar Chart
- **Requête** : `sum(ux_tutorial_step_completed_total) by (step_key)`
- **Description** : Permet de voir à quelle étape les utilisateurs abandonnent le tutoriel.

### 2.3 Friction des Formulaires
- **Type de Panel** : Table
- **Requête** : `avg(ux_form_friction_duration_seconds) by (form_name)`
- **Intérêt** : Identifie les formulaires trop complexes (ex: `add_transaction` vs `create_tontine`).

---

## 💰 Dashboard 3 : Business & Fiabilité
*Objectif : Suivre les revenus et la fiabilité des outils avancées.*

### 3.1 Succès des Paiements (Funnels)
- **Type de Panel** : Pie Chart
- **Requête** : `sum(business_payment_verify_total) by (success)`
- **Légende** : `true` = Succès, `false` = Échecs.

### 3.2 Fiabilité de l'OCR (Scan de Reçus)
- **Type de Panel** : Stat
- **Requête** : `sum(reliability_ocr_scan_total{found_amount="true"}) / sum(reliability_ocr_scan_total)`
- **Unité** : `Percent (0.0-1.0)`
- **Interprétation** : Quel pourcentage de scans a réussi à extraire le montant automatiquement.

### 3.3 Tendances de Catégories
- **Type de Panel** : Bar Chart (Horizontal)
- **Requête** : `sum(transaction_created_amount_total) by (category)`
- **Unité** : `Currency (XAF/EUR)`

---

## 🛠️ Manuel de création pas-à-pas

1. **Créer un Dashboard** : Cliquez sur le `+` bleu en haut à droite -> `Dashboard`.
2. **Ajouter un Panel** : Cliquez sur `Add Visualization`.
3. **Sélectionner la Source** : Choisissez `Prometheus`.
4. **Saisir la Query** : Copiez une des requêtes ci-dessus dans le champ `A`.
5. **Ajuster le Type** : Dans le menu de droite, changez `Time Series` par `Stat` ou `Gauge` selon le conseil.
6. **Nommer** : Donnez un titre clair dans `Panel options -> Title`.
7. **Sauvegarder** : Cliquez sur la disquette en haut à droite (`Save Dashboard`).

> [!TIP]
> Utilisez des **Variables** pour filtrer par version d'application (`version`) ou par pays (`country`) si vous avez configuré ces tags dans la télémétrie.
