import 'package:chopper/chopper.dart' hide HttpLoggingInterceptor;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:djangui/features/ai_tools/data/models/ai_tools_model.dart';
import 'package:djangui/features/auth/data/models/auth_response.dart';
import 'package:djangui/features/auth/data/models/user_model.dart';
import 'package:djangui/features/auth/data/models/badge_model.dart';
import 'package:djangui/features/budgets/data/models/budget_model.dart';
import 'package:djangui/features/challenges/data/models/challenge_model.dart';
import 'package:djangui/features/goals/data/models/goal_model.dart';
import 'package:djangui/features/insights/data/models/insight_model.dart';
import 'package:djangui/features/investments/data/models/investment_model.dart';
import 'package:djangui/features/payments/data/models/payment_model.dart';
import 'package:djangui/features/reports/data/models/reports_model.dart';
import 'package:djangui/features/transactions/data/models/transaction_model.dart';
import 'package:djangui/features/upload/data/models/upload_model.dart';
import 'package:djangui/features/coach/data/models/chat_message_model.dart';
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
