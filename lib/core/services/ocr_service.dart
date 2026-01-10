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

    final List<double> foundAmounts = [];
    final List<String> lines = [];

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        final text = line.text.trim();
        if (text.isEmpty) continue;

        lines.add(text);

        // Try to find amount
        final extractedAmount = _extractAmount(text);
        if (extractedAmount != null) {
          foundAmounts.add(extractedAmount);

          // If the line contains "TOTAL" or "NET", prioritize this amount
          if (text.toUpperCase().contains('TOTAL') ||
              text.toUpperCase().contains('NET') ||
              text.toUpperCase().contains('PAYER')) {
            amount = extractedAmount;
          }
        }

        // Try to find date
        date ??= _extractDate(text);
      }
    }

    // If no total found by keyword, take the largest amount found
    if (amount == null && foundAmounts.isNotEmpty) {
      foundAmounts.sort();
      amount = foundAmounts.last;
    }

    // Better description: look for the first line that isn't just numbers/dates
    for (String line in lines) {
      // Basic check: if more than 50% letters, likely a name
      final letterCount = line.replaceAll(RegExp(r'[^a-zA-Z]'), '').length;
      if (letterCount > line.length * 0.5 && line.length > 3) {
        description = line;
        break;
      }
    }

    // Basic category guessing
    String? category;
    if (description != null) {
      final descUpper = description.toUpperCase();
      if (descUpper.contains('RESTAURANT') ||
          descUpper.contains('FOOD') ||
          descUpper.contains('SNACK')) {
        category = 'Alimentation';
      } else if (descUpper.contains('SHELL') ||
          descUpper.contains('TOTAL') ||
          descUpper.contains('STATION')) {
        category = 'Transport';
      } else if (descUpper.contains('CASINO') || descUpper.contains('SUPER')) {
        category = 'Alimentation';
      } else if (descUpper.contains('PHARMACIE') ||
          descUpper.contains('HOSPITAL')) {
        category = 'Santé';
      }
    }

    return OCRResult(
      amount: amount,
      description: description,
      date: date,
      category: category,
    );
  }

  double? _extractAmount(String text) {
    // Matches numbers with currency symbols or standard amount formats
    // e.g. 12.50, 1,200.00, $12.99, 12€, 5000
    // Try to find numbers with 2 decimals first
    final RegExp decimalRegex = RegExp(r'(\d+[.,]\d{2})');
    final decimalMatch = decimalRegex.firstMatch(text);
    if (decimalMatch != null) {
      String cleanAmount = decimalMatch.group(1)!.replaceAll(',', '.');
      return double.tryParse(cleanAmount);
    }

    // Fallback to integers (at least 3 digits to avoid noise like dates or quantities)
    final RegExp integerRegex = RegExp(r'(\d{3,})');
    final integerMatch = integerRegex.firstMatch(text);
    if (integerMatch != null) {
      return double.tryParse(integerMatch.group(1)!);
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
