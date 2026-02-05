import 'package:chopper/chopper.dart' hide HttpLoggingInterceptor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kauri/features/ai_tools/data/models/ai_tools_model.dart';
import 'package:kauri/features/auth/data/models/auth_response.dart';
import 'package:kauri/features/auth/data/models/user_model.dart';
import 'package:kauri/features/auth/data/models/badge_model.dart';
import 'package:kauri/features/budgets/data/models/budget_model.dart';
import 'package:kauri/features/budgets/data/models/auto_budget_response.dart';
import 'package:kauri/features/challenges/data/models/challenge_model.dart';
import 'package:kauri/features/goals/data/models/goal_model.dart';
import 'package:kauri/features/insights/data/models/insight_model.dart';
import 'package:kauri/features/investments/data/models/investment_model.dart';
import 'package:kauri/features/payments/data/models/payment_model.dart';
import 'package:kauri/features/reports/data/models/reports_model.dart';
import 'package:kauri/features/transactions/data/models/transaction_model.dart';
import 'package:kauri/features/upload/data/models/upload_model.dart';
import 'package:kauri/features/coach/data/models/chat_message_model.dart';
import 'package:kauri/features/system/data/models/version_check_response.dart';
import 'package:kauri/features/system/data/models/public_settings_model.dart';
import 'package:kauri/features/support/data/models/support_ticket_model.dart';
import 'package:kauri/features/notifications/data/models/notification_model.dart';
import 'package:kauri/features/system/data/models/country_model.dart';
import 'package:kauri/features/auth/data/models/country_change_request.dart';
import 'package:kauri/features/voice/data/models/voice_response_model.dart';
import 'package:kauri/features/tontine/data/models/tontine_model.dart';
import 'package:kauri/features/user_subscriptions/data/models/subscription_model.dart';
import 'package:kauri/features/system/data/models/feature_flag_model.dart';
import 'package:kauri/features/analytics/data/models/analytics_models.dart';
import 'json_type_converter.dart';
import 'interceptors.dart';
import 'authenticator.dart';

/// Point d'entrée principal pour la configuration du client API utilisant Chopper.
/// Cette classe centralise la configuration du réseau, des intercepteurs, de l'authentification
/// et des convertisseurs de type JSON vers modèles Dart.
class KauriApiClient {
  /// Crée et configure une instance de [ChopperClient].
  /// Inclut le décodage JSON automatique pour tous les modèles du projet.
  static ChopperClient create() {
    final baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'https://api.kauri-app.com/api/v1';

    return ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      interceptors: [AuthInterceptor(), HttpLoggingInterceptor()],
      authenticator: KauriAuthenticator(),
      // Le convertisseur JsonToTypeConverter contient la table de correspondance
      // entre les réponses JSON brutes et les classes de modèles Dart.
      converter: JsonToTypeConverter({
        AuthResponse: (json) => AuthResponse.fromJson(json),
        UserModel: (json) => UserModel.fromJson(json),
        BadgeModel: (json) => BadgeModel.fromJson(json),
        TransactionModel: (json) => TransactionModel.fromJson(json),
        BudgetModel: (json) => BudgetModel.fromJson(json),
        GoalModel: (json) => GoalModel.fromJson(json),
        ChallengeModel: (json) => ChallengeModel.fromJson(json),
        UserChallengeModel: (json) => UserChallengeModel.fromJson(json),
        CategoryDistributionModel: (json) =>
            CategoryDistributionModel.fromJson(json),
        SpendingTrendModel: (json) => SpendingTrendModel.fromJson(json),
        InvestmentModel: (json) => InvestmentModel.fromJson(json),
        ChatMessageModel: (json) => ChatMessageModel.fromJson(json),
        PaymentInitResponseModel: (json) =>
            PaymentInitResponseModel.fromJson(json),
        DashboardReportModel: (json) => DashboardReportModel.fromJson(json),
        SpendingAnalysisModel: (json) => SpendingAnalysisModel.fromJson(json),
        SavingsTrendModel: (json) => SavingsTrendModel.fromJson(json),
        NarrativeReportModel: (json) => NarrativeReportModel.fromJson(json),
        OcrScanResponseModel: (json) => OcrScanResponseModel.fromJson(json),
        SmsParseResponseModel: (json) => SmsParseResponseModel.fromJson(json),
        BulkSmsParseResponseModel: (json) =>
            BulkSmsParseResponseModel.fromJson(json),
        UploadResponseModel: (json) => UploadResponseModel.fromJson(json),
        VersionCheckResponse: (json) => VersionCheckResponse.fromJson(json),
        PublicSettingsModel: (json) => PublicSettingsModel.fromJson(json),
        SupportTicketModel: (json) => SupportTicketModel.fromJson(json),
        SupportTicketReplyModel: (json) =>
            SupportTicketReplyModel.fromJson(json),
        NotificationModel: (json) => NotificationModel.fromJson(json),
        CountryModel: (json) => CountryModel.fromJson(json),
        CountryListResponse: (json) => CountryListResponse.fromJson(json),
        FeatureFlagModel: (json) => FeatureFlagModel.fromJson(json),
        CountryChangeRequestModel: (json) =>
            CountryChangeRequestModel.fromJson(json),
        VoiceResponseModel: (json) => VoiceResponseModel.fromJson(json),
        TontineModel: (json) => TontineModel.fromJson(json),
        TontineMemberModel: (json) => TontineMemberModel.fromJson(json),
        TontineContributionModel: (json) =>
            TontineContributionModel.fromJson(json),
        TontineMessageModel: (json) => TontineMessageModel.fromJson(json),
        SubscriptionModel: (json) => SubscriptionModel.fromJson(json),
        SubscriptionSuggestion: (json) => SubscriptionSuggestion.fromJson(json),
        SessionStartResponse: (json) => SessionStartResponse.fromJson(json),
        AutoBudgetResponse: (json) => AutoBudgetResponse.fromJson(json),
      }),
      // Convertisseur d'erreur spécifique pour les retours 4xx/5xx ayant une structure JSON.
      errorConverter: JsonToTypeConverter({
        AuthResponse: (json) => AuthResponse.fromJson(json),
        UserModel: (json) => UserModel.fromJson(json),
      }),
    );
  }
}
