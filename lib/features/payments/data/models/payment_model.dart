import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentInitResponseModel extends Equatable {
  final String url;
  final String reference;

  const PaymentInitResponseModel({required this.url, required this.reference});

  factory PaymentInitResponseModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentInitResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentInitResponseModelToJson(this);

  @override
  List<Object?> get props => [url, reference];
}
