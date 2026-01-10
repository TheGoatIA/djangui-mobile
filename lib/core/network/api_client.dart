import 'package:chopper/chopper.dart' hide HttpLoggingInterceptor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kauri/features/ai_tools/data/models/ai_tools_model.dart';
import 'package:kauri/features/auth/data/models/auth_response.dart';
import 'package:kauri/features/auth/data/models/user_model.dart';
import 'package:kauri/features/auth/data/models/badge_model.dart';
import 'package:kauri/features/budgets/data/models/budget_model.dart';
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
import 'json_type_converter.dart';
import 'interceptors.dart';
import 'authenticator.dart';

class KauriApiClient {
  static ChopperClient create() {
    final baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';

    return ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      interceptors: [AuthInterceptor(), HttpLoggingInterceptor()],
      authenticator: KauriAuthenticator(),
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
        CountryChangeRequestModel: (json) =>
            CountryChangeRequestModel.fromJson(json),
      }),
      errorConverter: JsonToTypeConverter({
        AuthResponse: (json) => AuthResponse.fromJson(json),
        UserModel: (json) => UserModel.fromJson(json),
      }),
    );
  }
}
