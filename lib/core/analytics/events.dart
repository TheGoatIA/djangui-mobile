/// Constantes pour tous les noms d'événements analytics.
///
/// Centralise les noms d'événements pour éviter les fautes de frappe
/// et faciliter la recherche/refactorisation.
///
/// Organisation :
///   - [AnalyticsEvents]     : noms des événements
///   - [AnalyticsParams]     : clés de paramètres réutilisables
///   - [AnalyticsAmountRange]: tranches de montants (JAMAIS de montants exacts)
library;

// ─────────────────────────────────────────────────────────────────────────────
// Noms d'événements
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AnalyticsEvents {
  // --- Navigation & Session ---
  static const String screenView = 'screen_view';
  static const String sessionStart = 'session_start';
  static const String sessionEnd = 'session_end';
  static const String appBackground = 'app_background';
  static const String appForeground = 'app_foreground';

  // --- Authentification & Sécurité ---
  static const String loginAttempt = 'login_attempt';
  static const String biometricPrompt = 'biometric_prompt';
  static const String pinChange = 'pin_change';
  static const String sessionExpired = 'session_expired';
  static const String logout = 'logout';
  static const String accountLocked = 'account_locked';
  static const String twoFactorAuth = 'two_factor_auth';

  // --- Envoi d'argent ---
  static const String sendMoneyStarted = 'send_money_started';
  static const String sendMoneyRecipientSelected = 'send_money_recipient_selected';
  static const String sendMoneyAmountEntered = 'send_money_amount_entered';
  static const String sendMoneySummaryViewed = 'send_money_summary_viewed';
  static const String sendMoneyConfirmed = 'send_money_confirmed';
  static const String sendMoneyCompleted = 'send_money_completed';
  static const String sendMoneyFailed = 'send_money_failed';
  static const String sendMoneyAbandoned = 'send_money_abandoned';

  // --- Dépôt ---
  static const String depositInitiated = 'deposit_initiated';
  static const String depositCompleted = 'deposit_completed';
  static const String depositFailed = 'deposit_failed';

  // --- Retrait ---
  static const String withdrawalInitiated = 'withdrawal_initiated';
  static const String withdrawalCompleted = 'withdrawal_completed';
  static const String withdrawalFailed = 'withdrawal_failed';

  // --- Paiement marchand ---
  static const String merchantPaymentStarted = 'merchant_payment_started';
  static const String merchantPaymentCompleted = 'merchant_payment_completed';

  // --- Actions rapides & QR ---
  static const String quickTransferUsed = 'quick_transfer_used';
  static const String qrCodeScanned = 'qr_code_scanned';
  static const String qrCodeGenerated = 'qr_code_generated';

  // --- Wallet & Solde ---
  static const String walletBalanceViewed = 'wallet_balance_viewed';
  static const String balanceHidden = 'balance_hidden';
  static const String balanceRevealed = 'balance_revealed';
  static const String walletCreated = 'wallet_created';
  static const String transactionHistoryViewed = 'transaction_history_viewed';
  static const String transactionDetailViewed = 'transaction_detail_viewed';
  static const String statementDownloaded = 'statement_downloaded';

  // --- Onboarding & KYC ---
  static const String onboardingStarted = 'onboarding_started';
  static const String onboardingStepCompleted = 'onboarding_step_completed';
  static const String onboardingStepFailed = 'onboarding_step_failed';
  static const String onboardingAbandoned = 'onboarding_abandoned';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String kycDocumentUploaded = 'kyc_document_uploaded';
  static const String kycSelfieTaken = 'kyc_selfie_taken';
  static const String kycStatusChanged = 'kyc_status_changed';
  static const String referralCodeEntered = 'referral_code_entered';

  // --- Notifications Push ---
  static const String pushNotificationReceived = 'push_notification_received';
  static const String pushNotificationTapped = 'push_notification_tapped';
  static const String pushNotificationDismissed = 'push_notification_dismissed';
  static const String pushPermissionRequested = 'push_permission_requested';
  static const String pushPermissionGranted = 'push_permission_granted';
  static const String pushPermissionDenied = 'push_permission_denied';

  // --- Paramètres & Profil ---
  static const String profileViewed = 'profile_viewed';
  static const String settingsChanged = 'settings_changed';
  static const String languageChanged = 'language_changed';
  static const String transactionLimitViewed = 'transaction_limit_viewed';
  static const String limitIncreaseRequested = 'limit_increase_requested';
  static const String supportChatOpened = 'support_chat_opened';
  static const String supportTicketCreated = 'support_ticket_created';
  static const String faqArticleViewed = 'faq_article_viewed';

  // --- Erreurs & Performance ---
  static const String apiError = 'api_error';
  static const String apiTimeout = 'api_timeout';
  static const String networkOfflineShown = 'network_offline_shown';
  static const String networkRecovered = 'network_recovered';
  static const String blocError = 'bloc_error';

  // --- Rétention & Produit ---
  static const String featureDiscovered = 'feature_discovered';
  static const String featureFirstUsed = 'feature_first_used';
  static const String searchPerformed = 'search_performed';
  static const String contactSynced = 'contact_synced';
  static const String beneficiaryAdded = 'beneficiary_added';
  static const String beneficiaryDeleted = 'beneficiary_deleted';
  static const String savingsGoalCreated = 'savings_goal_created';
}

// ─────────────────────────────────────────────────────────────────────────────
// Clés de paramètres
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AnalyticsParams {
  // Communs
  static const String screenName = 'screen_name';
  static const String screenClass = 'screen_class';
  static const String previousScreen = 'previous_screen';
  static const String sessionId = 'session_id';
  static const String durationMs = 'duration_ms';
  static const String sessionDurationSeconds = 'session_duration_seconds';
  static const String appVersion = 'app_version';
  static const String osVersion = 'os_version';
  static const String deviceType = 'device_type';
  static const String networkType = 'network_type';
  static const String success = 'success';
  static const String reason = 'reason';
  static const String method = 'method';
  static const String currency = 'currency';
  static const String amountRange = 'amount_range';
  static const String provider = 'provider';
  static const String entryPoint = 'entry_point';
  static const String step = 'step';
  static const String stepNumber = 'step_number';
  static const String atStep = 'at_step';
  static const String attemptNumber = 'attempt_number';
  static const String type = 'type';
  static const String inForeground = 'in_foreground';
  static const String authenticationRequired = 'authentication_required';
  static const String setting = 'setting';
  static const String newValue = 'new_value';
  static const String previousValue = 'previous_value';
  static const String endpoint = 'endpoint';
  static const String statusCode = 'status_code';
  static const String errorCode = 'error_code';
  static const String retryCount = 'retry_count';
  static const String screen = 'screen';
  static const String blocType = 'bloc_type';
  static const String errorType = 'error_type';

  // Auth spécifiques
  static const String failureReason = 'failure_reason';
  static const String attemptCount = 'attempt_count';
  static const String fallbackUsed = 'fallback_used';

  // Transaction spécifiques
  static const String paymentMethod = 'payment_method';
  static const String recipientType = 'recipient_type';
  static const String isFavorite = 'is_favorite';
  static const String inputMethod = 'input_method';
  static const String feesShown = 'fees_shown';
  static const String durationFromStartMs = 'duration_from_start_ms';
  static const String totalFlowDurationMs = 'total_flow_duration_ms';

  // KYC spécifiques
  static const String documentType = 'document_type';
  static const String captureMethod = 'capture_method';
  static const String livenessCheck = 'liveness_check';
  static const String previousStatus = 'previous_status';
  static const String newStatus = 'new_status';
  static const String completionPercentage = 'completion_percentage';
  static const String referralCodeUsed = 'referral_code_used';
  static const String valid = 'valid';

  // Notifications spécifiques
  static const String delayMs = 'delay_ms';
  static const String action = 'action';
  static const String promptType = 'prompt_type';

  // Produit spécifiques
  static const String feature = 'feature';
  static const String discoveryMethod = 'discovery_method';
  static const String daysSinceRegistration = 'days_since_registration';
  static const String queryLength = 'query_length';
  static const String resultCount = 'result_count';
  static const String resultClicked = 'result_clicked';
  static const String contactsCount = 'contacts_count';
  static const String matchedUsersCount = 'matched_users_count';
  static const String permissionGranted = 'permission_granted';
  static const String country = 'country';
  static const String beneficiaryType = 'beneficiary_type';
  static const String targetAmountRange = 'target_amount_range';
  static const String durationDays = 'duration_days';
  static const String autoSaveEnabled = 'auto_save_enabled';
  static const String balanceRange = 'balance_range';
  static const String visibilityToggle = 'visibility_toggle';
  static const String filterApplied = 'filter_applied';
  static const String sortOrder = 'sort_order';
  static const String pageNumber = 'page_number';
  static const String transactionType = 'transaction_type';
  static const String status = 'status';
  static const String ageDays = 'age_days';
  static const String format = 'format';
  static const String period = 'period';
  static const String walletType = 'wallet_type';
  static const String limitType = 'limit_type';
  static const String merchantCategory = 'merchant_category';
  static const String context = 'context';
  static const String relatedTransaction = 'related_transaction';
  static const String articleId = 'article_id';
  static const String category = 'category';
  static const String searchUsed = 'search_used';
  static const String offlineDurationSeconds = 'offline_duration_seconds';
  static const String autoRetryTriggered = 'auto_retry_triggered';
  static const String operationBlocked = 'operation_blocked';
  static const String requiresAuth = 'requires_auth';
  static const String backgroundDurationSeconds = 'background_duration_seconds';
  static const String screensVisited = 'screens_visited';
  static const String transactionsInitiated = 'transactions_initiated';
  static const String transactionsCompleted = 'transactions_completed';
  static const String timeoutMs = 'timeout_ms';
  static const String currentLimitRange = 'current_limit_range';
  static const String requestedLimitRange = 'requested_limit_range';
}

// ─────────────────────────────────────────────────────────────────────────────
// Tranches de montants — JAMAIS de montants exacts dans les analytics
// ─────────────────────────────────────────────────────────────────────────────

abstract final class AnalyticsAmountRange {
  static const String zero = '0';
  static const String micro = '1-1000';        // 0–1 000 XAF
  static const String small = '1001-10000';    // 1 001–10 000 XAF
  static const String medium = '10001-100000'; // 10 001–100 000 XAF
  static const String large = '100001+';       // > 100 000 XAF

  /// Retourne la tranche correspondant au montant fourni (en centimes ou entier).
  static String fromAmount(num amount) {
    if (amount <= 0) return zero;
    if (amount <= 1000) return micro;
    if (amount <= 10000) return small;
    if (amount <= 100000) return medium;
    return large;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Noms des traces Firebase Performance
// ─────────────────────────────────────────────────────────────────────────────

abstract final class PerformanceTraces {
  static const String transactionE2E = 'transaction_e2e';
  static const String walletBalanceLoad = 'wallet_balance_load';
  static const String transactionHistoryLoad = 'transaction_history_load';
  static const String kycDocumentUpload = 'kyc_document_upload';
  static const String authenticationFlow = 'authentication_flow';
}
