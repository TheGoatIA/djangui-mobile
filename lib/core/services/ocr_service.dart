import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:djangui/features/insights/data/datasources/ai_api_service.dart';

class OCRResult {
  final double? amount;
  final String? description;
  final String? category;
  final DateTime? date;

  OCRResult({this.amount, this.description, this.category, this.date});
}

@lazySingleton
class OCRService {
  final ImagePicker _picker = ImagePicker();
  final AiApiService _apiService;

  OCRService(this._apiService);

  Future<File?> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<OCRResult> scanReceipt(File image) async {
    final response = await _apiService.scanReceipt(image.path);

    if (response.isSuccessful && response.body != null) {
      final data = response.body!;
      return OCRResult(
        amount: (data['amount'] as num?)?.toDouble(),
        description: data['description'] as String?,
        category: data['category'] as String?,
        date: data['date'] != null
            ? DateTime.parse(data['date'] as String)
            : null,
      );
    } else {
      throw Exception('Erreur lors du scan du reçu: ${response.error}');
    }
  }
}
