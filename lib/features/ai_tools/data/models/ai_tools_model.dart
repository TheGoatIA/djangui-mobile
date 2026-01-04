import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'ai_tools_model.g.dart';

@JsonSerializable()
class OcrItemModel extends Equatable {
  final String name;
  final double price;

  const OcrItemModel({required this.name, required this.price});

  factory OcrItemModel.fromJson(Map<String, dynamic> json) =>
      _$OcrItemModelFromJson(json);
  Map<String, dynamic> toJson() => _$OcrItemModelToJson(this);

  @override
  List<Object?> get props => [name, price];
}

@JsonSerializable()
class OcrScanResponseModel extends Equatable {
  final String merchant;
  final double total;
  final List<OcrItemModel> items;

  const OcrScanResponseModel({
    required this.merchant,
    required this.total,
    required this.items,
  });

  factory OcrScanResponseModel.fromJson(Map<String, dynamic> json) =>
      _$OcrScanResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$OcrScanResponseModelToJson(this);

  @override
  List<Object?> get props => [merchant, total, items];
}

@JsonSerializable()
class SmsParseResponseModel extends Equatable {
  final double amount;
  final String merchant;
  final String category;

  const SmsParseResponseModel({
    required this.amount,
    required this.merchant,
    required this.category,
  });

  factory SmsParseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SmsParseResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SmsParseResponseModelToJson(this);

  @override
  List<Object?> get props => [amount, merchant, category];
}

@JsonSerializable()
class BulkSmsParseResponseModel extends Equatable {
  final int processed;
  final int imported;
  final int failed;

  const BulkSmsParseResponseModel({
    required this.processed,
    required this.imported,
    required this.failed,
  });

  factory BulkSmsParseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BulkSmsParseResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$BulkSmsParseResponseModelToJson(this);

  @override
  List<Object?> get props => [processed, imported, failed];
}
