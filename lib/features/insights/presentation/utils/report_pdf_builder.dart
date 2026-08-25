import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../../../reports/data/models/reports_model.dart';

/// Construit le PDF du rapport financier mensuel à partir des données déjà
/// chargées dans l'app (pas d'appel réseau) — reprend l'identité visuelle de
/// l'app (police Outfit déjà embarquée, palette émeraude/or) plutôt qu'un
/// PDF générique. Utilisé par `InsightsPage` pour remplacer le partage en
/// texte brut par un vrai document partageable/imprimable.
class ReportPdfBuilder {
  static const _emerald = PdfColor.fromInt(0xFF059669);
  static const _gold = PdfColor.fromInt(0xFFD4AF37);
  static const _darkText = PdfColor.fromInt(0xFF1F2937);
  static const _greyText = PdfColor.fromInt(0xFF6B7280);

  static Future<Uint8List> build({
    required NarrativeReportModel narrative,
    required String monthLabel,
    required String keyInsightsLabel,
    required String recommendationsLabel,
    required String healthScoreLabel,
    required String footerLabel,
  }) async {
    final regularData = await rootBundle.load(
      'assets/fonts/Outfit/Outfit-Regular.ttf',
    );
    final boldData = await rootBundle.load(
      'assets/fonts/Outfit/Outfit-Bold.ttf',
    );
    final regularFont = pw.Font.ttf(regularData);
    final boldFont = pw.Font.ttf(boldData);

    pw.MemoryImage? logo;
    try {
      final logoData = await rootBundle.load('assets/images/logo.png');
      logo = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {
      // Logo optionnel : le PDF reste correct sans (juste le texte "Kauri").
    }

    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: regularFont, bold: boldFont),
    );

    final scoreColor = narrative.healthScore == null
        ? _greyText
        : (narrative.healthScore! >= 70
              ? _emerald
              : (narrative.healthScore! >= 40
                    ? const PdfColor.fromInt(0xFFF59E0B)
                    : const PdfColor.fromInt(0xFFEF4444)));

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Row(
                  children: [
                    if (logo != null) ...[
                      pw.Image(logo, width: 28, height: 28),
                      pw.SizedBox(width: 8),
                    ],
                    pw.Text(
                      'KAURI',
                      style: pw.TextStyle(
                        font: boldFont,
                        fontSize: 16,
                        color: _emerald,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                pw.Text(
                  monthLabel,
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 11,
                    color: _greyText,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 12),
            pw.Divider(color: _emerald, thickness: 1),
            pw.SizedBox(height: 12),
          ],
        ),
        footer: (context) => pw.Column(
          children: [
            pw.Divider(color: const PdfColor.fromInt(0xFFE5E7EB)),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  footerLabel,
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 9,
                    color: _greyText,
                  ),
                ),
                pw.Text(
                  '${context.pageNumber}/${context.pagesCount}',
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 9,
                    color: _greyText,
                  ),
                ),
              ],
            ),
          ],
        ),
        build: (context) => [
          pw.Text(
            narrative.title,
            style: pw.TextStyle(font: boldFont, fontSize: 20, color: _darkText),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            children: [
              if (narrative.healthScore != null) ...[
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColor(
                      scoreColor.red,
                      scoreColor.green,
                      scoreColor.blue,
                      0.12,
                    ),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    '$healthScoreLabel : ${narrative.healthScore}/100',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 11,
                      color: scoreColor,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
              ],
              if (narrative.tone != null)
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: const PdfColor.fromInt(0x1A059669),
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    narrative.tone!,
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 10,
                      color: _emerald,
                    ),
                  ),
                ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            narrative.summary,
            style: pw.TextStyle(
              font: regularFont,
              fontSize: 11,
              color: _darkText,
              lineSpacing: 3,
            ),
            textAlign: pw.TextAlign.justify,
          ),
          if (narrative.topInsights.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text(
              keyInsightsLabel,
              style: pw.TextStyle(font: boldFont, fontSize: 13, color: _emerald),
            ),
            pw.SizedBox(height: 8),
            ...narrative.topInsights.map(
              (insight) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '•  ',
                      style: pw.TextStyle(font: boldFont, color: _emerald),
                    ),
                    pw.Expanded(
                      child: pw.Text(
                        insight,
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 10.5,
                          color: _darkText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (narrative.recommendations.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text(
              recommendationsLabel,
              style: pw.TextStyle(font: boldFont, fontSize: 13, color: _gold),
            ),
            pw.SizedBox(height: 8),
            ...narrative.recommendations.map(
              (rec) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: const PdfColor.fromInt(0xFFFAFAF7),
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(
                    color: const PdfColor.fromInt(0xFFE5E7EB),
                  ),
                ),
                child: pw.Text(
                  rec,
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 10.5,
                    color: _darkText,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return doc.save();
  }
}
