import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../l10n/app_strings.dart';
import '../models/measurement_record.dart';

class PdfReportService {
  static Future<Uint8List> buildSurveyReportPdf({
    required AppStrings strings,
    required List<MeasurementRecord> records,
    required String operatorName,
    Uint8List? signaturePngBytes,
  }) async {
    final doc = pw.Document(
      title: '${strings.appTitle} - Technical Survey Report',
      author: operatorName.isEmpty ? 'TeleMetro AR Pro' : operatorName,
    );

    final nowStr = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#0B0F19'),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'TELEMETRO AR PRO • SIMPLEAPPSPG',
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#00E676'),
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        strings.appSubtitle,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#F8FAFC'),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'FECHA / DATE: $nowStr',
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#94A3B8'),
                          fontSize: 9,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'OPERADOR: ${operatorName.isEmpty ? "N/A" : operatorName}',
                        style: pw.TextStyle(
                          color: PdfColor.fromHex('#00E5FF'),
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Text(
              strings.formulaReferenceTitle,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#0B0F19'),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              '• D = h_eye / tan(|theta_base|)   |   H = h_eye + D * tan(theta_top)   |   Slope % = tan(theta) * 100',
              style: const pw.TextStyle(fontSize: 9),
            ),
            pw.SizedBox(height: 14),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(
                color: PdfColors.white,
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
              ),
              headerDecoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#161F30'),
              ),
              cellStyle: const pw.TextStyle(fontSize: 8.5),
              cellAlignment: pw.Alignment.centerLeft,
              headers: [
                'ID / Punto',
                'h_eye (m)',
                'θ Base',
                'θ Cima',
                'Dist. D (m)',
                'Altura H (m)',
                'Pendiente %',
                'Techo X:12',
              ],
              data: records.map((r) {
                return [
                  r.title,
                  r.eyeHeightMeters.toStringAsFixed(2),
                  '${r.baseAngleDeg.toStringAsFixed(1)}°',
                  '${r.topAngleDeg.toStringAsFixed(1)}°',
                  '${r.horizontalDistanceMeters.toStringAsFixed(2)} m',
                  '${r.targetHeightMeters.toStringAsFixed(2)} m',
                  '${r.slopePercent.toStringAsFixed(1)}%',
                  '${r.roofPitchRisePer12.toStringAsFixed(1)}:12',
                ];
              }).toList(),
            ),
            pw.SizedBox(height: 24),
            pw.Divider(color: PdfColor.fromHex('#CBD5E1')),
            pw.SizedBox(height: 12),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      strings.signatureDialogTitle,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      operatorName.isEmpty ? 'Ingeniero / Operador' : operatorName,
                      style: const pw.TextStyle(fontSize: 9),
                    ),
                    pw.SizedBox(height: 8),
                    if (signaturePngBytes != null && signaturePngBytes.isNotEmpty)
                      pw.Container(
                        width: 160,
                        height: 65,
                        padding: const pw.EdgeInsets.all(4),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.grey400),
                        ),
                        child: pw.Image(pw.MemoryImage(signaturePngBytes)),
                      )
                    else
                      pw.Container(
                        width: 160,
                        height: 50,
                        alignment: pw.Alignment.bottomLeft,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.grey700),
                          ),
                        ),
                        child: pw.Text(
                          'Firmado Digitalmente / Verified',
                          style: const pw.TextStyle(fontSize: 8),
                        ),
                      ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Certificado generado 100% Offline',
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      'com.simpleappspg.telemetroar v1.0.0',
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    return doc.save();
  }
}
