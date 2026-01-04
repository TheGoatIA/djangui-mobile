import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

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
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  Future<File?> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  Future<OCRResult> scanReceipt(File image) async {
    final inputImage = InputImage.fromFile(image);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    return _parseReceipt(recognizedText);
  }

  OCRResult _parseReceipt(RecognizedText recognizedText) {
    String? description;
    double? amount;
    DateTime? date;

    // Simple heuristic: First non-empty line is often the merchant name (description)
    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        if (description == null && line.text.trim().isNotEmpty) {
          description = line.text.trim();
        }

        // Try to find amount
        amount ??= _extractAmount(line.text);

        // Try to find date
        date ??= _extractDate(line.text);
      }
    }

    return OCRResult(
      amount: amount,
      description: description,
      date: date,
      // Category is hard to guess without NLP, leaving null for user to fill
      category: null,
    );
  }

  double? _extractAmount(String text) {
    // Matches numbers with currency symbols or standard amount formats
    // e.g. 12.50, 1,200.00, $12.99, 12€
    final RegExp amountRegex = RegExp(r'(\d+[.,]\d{2})');
    final match = amountRegex.firstMatch(text);
    if (match != null) {
      String cleanAmount = match.group(1)!.replaceAll(',', '.');
      return double.tryParse(cleanAmount);
    }
    return null;
  }

  DateTime? _extractDate(String text) {
    // Matches DD/MM/YYYY or YYYY-MM-DD
    final RegExp dateRegex = RegExp(r'(\d{2}/\d{2}/\d{4})|(\d{4}-\d{2}-\d{2})');
    final match = dateRegex.firstMatch(text);
    if (match != null) {
      try {
        if (match.group(1) != null) {
          // DD/MM/YYYY
          final parts = match.group(1)!.split('/');
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        } else if (match.group(2) != null) {
          // YYYY-MM-DD
          return DateTime.parse(match.group(2)!);
        }
      } catch (_) {}
    }
    return null;
  }

  void dispose() {
    _textRecognizer.close();
  }
}
