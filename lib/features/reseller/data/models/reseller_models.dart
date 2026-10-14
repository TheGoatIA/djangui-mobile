class ResellerAccountModel {
  final String id;
  final String serviceName;
  final String? servicePreset;
  final String category;
  final String? iconUrl;
  final String brandColor;
  final double billingCost;
  final String billingCurrency;
  final String billingFrequency;
  final DateTime nextRenewalDate;
  final int maxSlots;
  final int slotsCount;
  final int occupiedSlots;
  final int vacantSlots;
  final double totalRevenue;
  final double netMargin;
  final String status;
  final List<ResellerSlotModel> slots;

  ResellerAccountModel({
    required this.id,
    required this.serviceName,
    this.servicePreset,
    required this.category,
    this.iconUrl,
    required this.brandColor,
    required this.billingCost,
    required this.billingCurrency,
    required this.billingFrequency,
    required this.nextRenewalDate,
    required this.maxSlots,
    required this.slotsCount,
    required this.occupiedSlots,
    required this.vacantSlots,
    required this.totalRevenue,
    required this.netMargin,
    required this.status,
    required this.slots,
  });

  factory ResellerAccountModel.fromJson(Map<String, dynamic> json) {
    return ResellerAccountModel(
      id: json['_id'] ?? json['id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      servicePreset: json['servicePreset'],
      category: json['category'] ?? 'video',
      iconUrl: json['iconUrl'],
      brandColor: json['brandColor'] ?? '#059669',
      billingCost: (json['billingCost'] as num?)?.toDouble() ?? 0.0,
      billingCurrency: json['billingCurrency'] ?? 'XAF',
      billingFrequency: json['billingFrequency'] ?? 'monthly',
      nextRenewalDate: json['nextRenewalDate'] != null
          ? DateTime.parse(json['nextRenewalDate'])
          : DateTime.now(),
      maxSlots: json['maxSlots'] ?? 4,
      slotsCount: json['slotsCount'] ?? 0,
      occupiedSlots: json['occupiedSlots'] ?? 0,
      vacantSlots: json['vacantSlots'] ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      netMargin: (json['netMargin'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'active',
      slots: (json['slots'] as List<dynamic>?)
              ?.map((s) => ResellerSlotModel.fromJson(s))
              .toList() ??
          [],
    );
  }
}

class ResellerSlotModel {
  final String id;
  final String masterAccountId;
  final String profileName;
  final String clientName;
  final String clientPhone;
  final String? clientEmail;
  final String? whatsappNumber;
  final String preferredChannel;
  final double price;
  final String currency;
  final DateTime currentPeriodEnd;
  final String status; // active, due_soon, overdue, blocked, vacant

  ResellerSlotModel({
    required this.id,
    required this.masterAccountId,
    required this.profileName,
    required this.clientName,
    required this.clientPhone,
    this.clientEmail,
    this.whatsappNumber,
    required this.preferredChannel,
    required this.price,
    required this.currency,
    required this.currentPeriodEnd,
    required this.status,
  });

  factory ResellerSlotModel.fromJson(Map<String, dynamic> json) {
    final client = json['client'] as Map<String, dynamic>? ?? {};
    return ResellerSlotModel(
      id: json['_id'] ?? json['id'] ?? '',
      masterAccountId: json['masterAccountId'] ?? '',
      profileName: json['profileName'] ?? '',
      clientName: client['fullName'] ?? '',
      clientPhone: client['phone'] ?? '',
      clientEmail: client['email'],
      whatsappNumber: client['whatsappNumber'],
      preferredChannel: client['preferredReminderChannel'] ?? 'whatsapp',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'XAF',
      currentPeriodEnd: json['currentPeriodEnd'] != null
          ? DateTime.parse(json['currentPeriodEnd'])
          : DateTime.now(),
      status: json['status'] ?? 'active',
    );
  }
}

class ResellerDashboardStatsModel {
  final int totalAccounts;
  final int totalSlotsCapacity;
  final int occupiedSlots;
  final int vacantSlots;
  final int occupancyRate;
  final double mrr;
  final double totalMasterCost;
  final double netProfit;
  final int netMarginPercentage;
  final String currency;
  final int dueSoonCount;
  final int overdueCount;
  final int blockedCount;

  ResellerDashboardStatsModel({
    required this.totalAccounts,
    required this.totalSlotsCapacity,
    required this.occupiedSlots,
    required this.vacantSlots,
    required this.occupancyRate,
    required this.mrr,
    required this.totalMasterCost,
    required this.netProfit,
    required this.netMarginPercentage,
    required this.currency,
    required this.dueSoonCount,
    required this.overdueCount,
    required this.blockedCount,
  });

  factory ResellerDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final fin = json['financials'] as Map<String, dynamic>? ?? {};
    final status = json['statusCounts'] as Map<String, dynamic>? ?? {};
    return ResellerDashboardStatsModel(
      totalAccounts: json['totalAccounts'] ?? 0,
      totalSlotsCapacity: json['totalSlotsCapacity'] ?? 0,
      occupiedSlots: json['occupiedSlots'] ?? 0,
      vacantSlots: json['vacantSlots'] ?? 0,
      occupancyRate: json['occupancyRate'] ?? 0,
      mrr: (fin['mrr'] as num?)?.toDouble() ?? 0.0,
      totalMasterCost: (fin['totalMasterCost'] as num?)?.toDouble() ?? 0.0,
      netProfit: (fin['netProfit'] as num?)?.toDouble() ?? 0.0,
      netMarginPercentage: fin['netMarginPercentage'] ?? 0,
      currency: fin['currency'] ?? 'XAF',
      dueSoonCount: status['due_soon'] ?? 0,
      overdueCount: status['overdue'] ?? 0,
      blockedCount: status['blocked'] ?? 0,
    );
  }
}