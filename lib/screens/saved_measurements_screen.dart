import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';
import '../calculators/telemetro_calculator.dart';
import '../l10n/app_strings.dart';
import '../models/measurement_record.dart';
import '../services/pdf_report_service.dart';
import '../theme/app_theme.dart';

class SavedMeasurementsScreen extends StatefulWidget {
  final AppStrings strings;
  final List<MeasurementRecord> records;
  final ValueChanged<MeasurementRecord> onAddRecord;
  final ValueChanged<String> onDeleteRecord;
  final VoidCallback onClearAll;

  const SavedMeasurementsScreen({
    super.key,
    required this.strings,
    required this.records,
    required this.onAddRecord,
    required this.onDeleteRecord,
    required this.onClearAll,
  });

  @override
  State<SavedMeasurementsScreen> createState() =>
      _SavedMeasurementsScreenState();
}

class _SavedMeasurementsScreenState extends State<SavedMeasurementsScreen> {
  void _addSampleSurvey() {
    final id = const Uuid().v4().substring(0, 6).toUpperCase();
    final calc = TelemetroCalculator.computeAll(
      eyeHeightMeters: 1.65,
      baseAngleDeg: -16.0,
      topAngleDeg: 31.0,
    );
    final record = MeasurementRecord(
      id: id,
      title: 'SURVEY-$id',
      timestampIso: DateTime.now().toIso8601String(),
      eyeHeightMeters: calc.eyeHeightMeters,
      baseAngleDeg: calc.baseAngleDeg,
      topAngleDeg: calc.topAngleDeg,
      horizontalDistanceMeters: calc.horizontalDistanceMeters,
      targetHeightMeters: calc.targetHeightMeters,
      slopePercent: calc.slopePercent,
      roofPitchRisePer12: calc.roofPitchRisePer12,
      azimuthDeg: 145.0,
      pressureHpa: 1013.2,
    );
    widget.onAddRecord(record);
  }

  Future<void> _openSignatureAndExportDialog() async {
    final s = widget.strings;
    final operatorCtrl = TextEditingController(text: 'Ing. Residente');
    final sigController = SignatureController(
      penStrokeWidth: 2.8,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceSlate,
          title: Text(
            s.signatureDialogTitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 340,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: const Key('inputOperatorName'),
                    controller: operatorCtrl,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      labelText: s.operatorNameLabel,
                      labelStyle:
                          const TextStyle(color: AppTheme.textSecondary),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppTheme.borderColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppTheme.accentGreen),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.accentGreen),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Signature(
                        controller: sigController,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: sigController.clear,
                      icon: const Icon(Icons.cleaning_services_rounded, size: 16),
                      label: Text(s.clearSignatureButton),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(s.cancelButton),
            ),
            ElevatedButton.icon(
              key: const Key('btnConfirmGeneratePdf'),
              onPressed: () async {
                final sigBytes = await sigController.toPngBytes();
                final opName = operatorCtrl.text.trim();
                if (ctx.mounted) {
                  Navigator.of(ctx).pop();
                }
                final bytes = await PdfReportService.buildSurveyReportPdf(
                  strings: s,
                  records: widget.records,
                  operatorName: opName,
                  signaturePngBytes: sigBytes,
                );
                await Printing.layoutPdf(
                  name: 'TeleMetroAR_Survey_Report.pdf',
                  onLayout: (_) async => bytes,
                );
              },
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
              label: Text(s.generatePdfButton),
            ),
          ],
        );
      },
    );

    operatorCtrl.dispose();
    sigController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('btnExportPdfModal'),
                  onPressed: widget.records.isEmpty
                      ? null
                      : _openSignatureAndExportDialog,
                  icon: const Icon(Icons.draw_rounded, size: 18),
                  label: Text(s.exportPdfButton),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                key: const Key('btnAddQuickSurvey'),
                onPressed: _addSampleSurvey,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: Text(s.addDemoMeasurementButton),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (widget.records.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                key: const Key('btnClearAllRecords'),
                onPressed: widget.onClearAll,
                icon: const Icon(
                  Icons.delete_sweep_rounded,
                  size: 18,
                  color: AppTheme.accentRed,
                ),
                label: Text(
                  s.deleteAllButton,
                  style: const TextStyle(
                    color: AppTheme.accentRed,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Expanded(
            child: widget.records.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        s.emptyLogbookMessage,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: widget.records.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final rec = widget.records[index];
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceSlate,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.gps_fixed_rounded,
                                      color: AppTheme.accentGreen,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      rec.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    size: 20,
                                    color: AppTheme.textSecondary,
                                  ),
                                  onPressed: () =>
                                      widget.onDeleteRecord(rec.id),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 14,
                              runSpacing: 6,
                              children: [
                                _MiniBadge(
                                  label: 'D',
                                  value:
                                      '${rec.horizontalDistanceMeters.toStringAsFixed(2)} m',
                                  color: AppTheme.accentGreen,
                                ),
                                _MiniBadge(
                                  label: 'H',
                                  value:
                                      '${rec.targetHeightMeters.toStringAsFixed(2)} m',
                                  color: AppTheme.accentCyan,
                                ),
                                _MiniBadge(
                                  label: 'θ_base',
                                  value:
                                      '${rec.baseAngleDeg.toStringAsFixed(1)}°',
                                  color: AppTheme.textPrimary,
                                ),
                                _MiniBadge(
                                  label: 'θ_top',
                                  value:
                                      '${rec.topAngleDeg.toStringAsFixed(1)}°',
                                  color: AppTheme.accentAmber,
                                ),
                                _MiniBadge(
                                  label: 'Slope',
                                  value:
                                      '${rec.slopePercent.toStringAsFixed(1)}%',
                                  color: AppTheme.accentGreen,
                                ),
                                _MiniBadge(
                                  label: 'Pitch',
                                  value:
                                      '${rec.roofPitchRisePer12.toStringAsFixed(1)}:12',
                                  color: AppTheme.accentCyan,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniBadge({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.backgroundObsidian,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
