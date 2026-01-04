import 'package:chopper/chopper.dart' hide HttpLoggingInterceptor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../features/ai_tools/data/models/ai_tools_model.dart';
import '../../features/auth/data/models/auth_response.dart';
import '../../features/auth/data/models/user_model.dart';
import '../../features/auth/data/models/badge_model.dart';
import '../../features/budgets/data/models/budget_model.dart';
import '../../features/challenges/data/models/challenge_model.dart';
import '../../features/goals/data/models/goal_model.dart';
import '../../features/insights/data/models/insight_model.dart';
import '../../features/investments/data/models/investment_model.dart';
import '../../features/payments/data/models/payment_model.dart';
import '../../features/reports/data/models/reports_model.dart';
import '../../features/transactions/data/models/transaction_model.dart';
import '../../features/upload/data/models/upload_model.dart';
import '../../features/coach/data/models/chat_message_model.dart';
import 'json_type_converter.dart';
import 'interceptors.dart';
import 'authenticator.dart';

class DjanguiApiClient {
  static ChopperClient create() {
    final baseUrl =
        dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000/api/v1';

    return ChopperClient(
      baseUrl: Uri.parse(baseUrl),
      interceptors: [AuthInterceptor(), HttpLoggingInterceptor()],
      authenticator: DjanguiAuthenticator(),
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
      }),
      errorConverter: JsonToTypeConverter({
        AuthResponse: (json) => AuthResponse.fromJson(json),
        UserModel: (json) => UserModel.fromJson(json),
      }),
    );
  }
}
