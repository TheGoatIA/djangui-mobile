import 'package:injectable/injectable.dart';
import 'package:kauri/features/insights/data/datasources/ai_api_service.dart';
import '../../../../core/network/api_response_extensions.dart';

@lazySingleton
class AIRemoteDataSource {
  final AiApiService _apiService;

  AIRemoteDataSource(this._apiService);

  Future<String> getNarrativeReport() async {
    final response = await _apiService.getNarrativeReport();
    if (response.isSuccessful && response.body != null) {
      return response.body!['narrative'] as String? ??
          "Aucune analyse disponible.";
    }
    throw Exception(response.errorMessage);
  }
}
