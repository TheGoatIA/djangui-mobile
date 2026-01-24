import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

/// Représente les données extraites d'un reçu après analyse OCR.
class OCRResult {
  /// Montant total détecté sur le reçu.
  final double? amount;

  /// Libellé ou nom du commerçant détecté.
  final String? description;

  /// Catégorie de dépense suggérée (ex: Alimentation, Santé).
  final String? category;

  /// Date de la transaction détectée.
  final DateTime? date;

  OCRResult({this.amount, this.description, this.category, this.date});
}

/// Service utilisant Google ML Kit pour extraire du texte à partir d'images de reçus.
///
/// Ce service permet de transformer une photo de ticket de caisse en une
/// transaction structurée de manière automatisée.
@lazySingleton
class OCRService {
  final ImagePicker _picker = ImagePicker();
  final _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  /// Ouvre la caméra ou la galerie pour permettre à l'utilisateur de sélectionner une image.
  Future<File?> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }

  /// Analyse une image de reçu et tente d'en extraire le montant, la date et le commerçant.
  Future<OCRResult> scanReceipt(File image) async {
    final inputImage = InputImage.fromFile(image);
    final recognizedText = await _textRecognizer.processImage(inputImage);

    return _parseReceipt(recognizedText);
  }

  /// Logique de parsing heuristique pour identifier les informations clés dans le texte brut.
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

        // Recherche de montants potentiels dans la ligne
        final extractedAmount = _extractAmount(text);
        if (extractedAmount != null) {
          foundAmounts.add(extractedAmount);

          // Priorise les montants associés à des mots-clés de totalisation
          if (text.toUpperCase().contains('TOTAL') ||
              text.toUpperCase().contains('NET') ||
              text.toUpperCase().contains('PAYER')) {
            amount = extractedAmount;
          }
        }

        // Tentative d'extraction de la date si non encore trouvée
        date ??= _extractDate(text);
      }
    }

    // Si aucun "Total" explicite n'est trouvé, on prend la plus grande valeur numérique détectée
    if (amount == null && foundAmounts.isNotEmpty) {
      foundAmounts.sort();
      amount = foundAmounts.last;
    }

    // Détermination du commerçant (description) : cherche la première ligne textuelle significative
    for (String line in lines) {
      final letterCount = line.replaceAll(RegExp(r'[^a-zA-Z]'), '').length;
      if (letterCount > line.length * 0.5 && line.length > 3) {
        description = line;
        break;
      }
    }

    // Suggestion de catégorie basée sur des mots-clés dans la description
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

  /// Extrait un nombre flottant d'une chaîne de caractères (gère les séparateurs . et ,).
  double? _extractAmount(String text) {
    // Regex pour les nombres décimaux
    final RegExp decimalRegex = RegExp(r'(\d+[.,]\d{2})');
    final decimalMatch = decimalRegex.firstMatch(text);
    if (decimalMatch != null) {
      String cleanAmount = decimalMatch.group(1)!.replaceAll(',', '.');
      return double.tryParse(cleanAmount);
    }

    // Regex pour les entiers longs (évite de capturer des petites quantités ou des jours)
    final RegExp integerRegex = RegExp(r'(\d{3,})');
    final integerMatch = integerRegex.firstMatch(text);
    if (integerMatch != null) {
      return double.tryParse(integerMatch.group(1)!);
    }
    return null;
  }

  /// Identifie une date au format DD/MM/YYYY ou YYYY-MM-DD.
  DateTime? _extractDate(String text) {
    final RegExp dateRegex = RegExp(r'(\d{2}/\d{2}/\d{4})|(\d{4}-\d{2}-\d{2})');
    final match = dateRegex.firstMatch(text);
    if (match != null) {
      try {
        if (match.group(1) != null) {
          final parts = match.group(1)!.split('/');
          return DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
        } else if (match.group(2) != null) {
          return DateTime.parse(match.group(2)!);
        }
      } catch (_) {}
    }
    return null;
  }

  /// Libère les ressources du TextRecognizer lors de la destruction du service.
  void dispose() {
    _textRecognizer.close();
  }
}
