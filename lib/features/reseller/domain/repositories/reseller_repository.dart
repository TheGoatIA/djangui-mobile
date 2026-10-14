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

  /// Récupère tous les comptes maîtres du revendeur connecté.
  ///
  /// L'API pagine cette route côté serveur (par défaut 20 comptes/page) pour
  /// protéger le backend d'une requête non bornée — un revendeur en forfait
  /// Business n'a pas de plafond de comptes (voir RESELLER_LIMITS côté API).
  /// L'app ne propose pas encore de pagination/scroll infini sur cet écran,
  /// donc on récupère toutes les pages ici et on renvoie la liste complète,
  /// pour préserver exactement le comportement (et la signature) attendus par
  /// le bloc/l'écran existants.
  Future<List<ResellerAccountModel>> getAccounts() async {
    const maxPages = 25; // garde-fou : 25 x 20 = 500 comptes, largement au-delà de tout usage réel
    const pageSize = 20;

    final accounts = <ResellerAccountModel>[];
    var page = 1;
    var totalPages = 1;

    do {
      final response = await _apiService.getAccounts(page: page, limit: pageSize);
      if (!response.isSuccessful || response.body?.data == null) {
        if (page == 1) {
          throw Exception('Erreur lors du chargement des comptes');
        }
        break; // une page suivante en échec ne doit pas perdre ce qui a déjà été chargé
      }

      accounts.addAll(
        response.body!.data!.map((item) => ResellerAccountModel.fromJson(item)),
      );

      totalPages = response.body!.pagination?.pages ?? 1;
      page++;
    } while (page <= totalPages && page <= maxPages);

    return accounts;
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