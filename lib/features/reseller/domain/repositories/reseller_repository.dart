import '../../data/datasources/reseller_api_service.dart';
import '../../data/models/reseller_models.dart';

class ResellerRepository {
  final ResellerApiService _apiService;

  ResellerRepository(this._apiService);

  Future<ResellerDashboardStatsModel> getDashboardStats() async {
    final response = await _apiService.getDashboardStats();
    if (response.isSuccessful && response.body?.data != null) {
      return ResellerDashboardStatsModel.fromJson(response.body!.data!);
    }
    throw Exception('Erreur lors du chargement des statistiques revendeur');
  }

  Future<List<ResellerAccountModel>> getAccounts() async {
    final response = await _apiService.getAccounts();
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!
          .map((item) => ResellerAccountModel.fromJson(item))
          .toList();
    }
    throw Exception('Erreur lors du chargement des comptes');
  }

  Future<void> createAccount(Map<String, dynamic> body) async {
    final response = await _apiService.createAccount(body);
    if (!response.isSuccessful) {
      throw Exception('Erreur lors de la création du compte');
    }
  }

  Future<Map<String, dynamic>> unlockVault(String accountId) async {
    final response = await _apiService.unlockVault(accountId);
    if (response.isSuccessful && response.body?.data != null) {
      return response.body!.data!;
    }
    throw Exception('Échec du déverrouillage du coffre-fort');
  }

  Future<void> addSlot(String accountId, Map<String, dynamic> body) async {
    final response = await _apiService.addSlot(accountId, body);
    if (!response.isSuccessful) {
      throw Exception('Erreur lors de l\'ajout du slot');
    }
  }

  Future<void> deleteSlot(String slotId) async {
    final response = await _apiService.deleteSlot(slotId);
    if (!response.isSuccessful) {
      throw Exception('Erreur lors de la suppression du slot');
    }
  }

  Future<void> deleteAccount(String accountId) async {
    final response = await _apiService.deleteAccount(accountId);
    if (!response.isSuccessful) {
      throw Exception('Erreur lors de la suppression du compte');
    }
  }

  Future<void> recordPayment(String slotId, Map<String, dynamic> body) async {
    final response = await _apiService.recordSlotPayment(slotId, body);
    if (!response.isSuccessful) {
      throw Exception('Erreur lors de l\'enregistrement du paiement');
    }
  }
}