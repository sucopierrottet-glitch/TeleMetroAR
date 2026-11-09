import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../calculators/telemetro_calculator.dart';
import '../l10n/app_strings.dart';
import '../services/sensor_service.dart';
import '../theme/app_theme.dart';

class ClinometerLevelScreen extends StatefulWidget {
  final AppStrings strings;
  final SensorService sensorService;
  final SensorSnapshot currentSnapshot;
  final VoidCallback onRefreshSensor;

  const ClinometerLevelScreen({
    super.key,
    required this.strings,
    required this.sensorService,
    required this.currentSnapshot,
    required this.onRefreshSensor,
  });

  @override
  State<ClinometerLevelScreen> createState() => _ClinometerLevelScreenState();
}

class _ClinometerLevelScreenState extends State<ClinometerLevelScreen> {
  double _pitchTare = 0.0;
  double _rollTare = 0.0;

  void _tareZero() {
    setState(() {
      _pitchTare = widget.currentSnapshot.pitch;
      _rollTare = widget.currentSnapshot.roll;
    });
  }

  void _clearTare() {
    setState(() {
      _pitchTare = 0.0;
      _rollTare = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final calibratedPitch =
        (widget.currentSnapshot.pitch - _pitchTare).clamp(-89.0, 89.0);
    final calibratedRoll =
        (widget.currentSnapshot.roll - _rollTare).clamp(-89.0, 89.0);

    final totalTilt = math.sqrt(
      calibratedPitch * calibratedPitch + calibratedRoll * calibratedRoll,
    );
    final isLevel = totalTilt < 0.6;

    final slopePct = TelemetroCalculator.calculateSlopePercent(calibratedPitch);
    final roofRise =
        TelemetroCalculator.calculateRoofPitchRise(calibratedPitch);
    final baroAlt = TelemetroCalculator.calculateBarometricAltitude(
      widget.currentSnapshot.pressureHpa,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Level status banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isLevel
                  ? AppTheme.accentGreen.withValues(alpha: 0.16)
                  : AppTheme.accentAmber.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isLevel ? AppTheme.accentGreen : AppTheme.accentAmber,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isLevel
                      ? Icons.check_circle_rounded
                      : Icons.warning_amber_rounded,
                  color: isLevel ? AppTheme.accentGreen : AppTheme.accentAmber,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  isLevel ? s.levelLockedLabel : s.levelTiltedLabel,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color:
                        isLevel ? AppTheme.accentGreen : AppTheme.accentAmber,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 360 Bullseye Bubble Level CustomPainter
          Center(
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF070C15),
                border: Border.all(
                  color: isLevel ? AppTheme.accentGreen : AppTheme.borderColor,
                  width: 2,
                ),
              ),
              child: CustomPaint(
                painter: _BullseyeLevelPainter(
                  pitchDeg: calibratedPitch,
                  rollDeg: calibratedRoll,
                  isLevel: isLevel,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tare / Reset Calibration Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  key: const Key('btnTareZero'),
                  onPressed: _tareZero,
                  icon: const Icon(Icons.filter_center_focus_rounded, size: 18),
                  label: Text(s.zeroCalibrateButton),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('btnClearTare'),
                  onPressed: _clearTare,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: Text(s.clearTareButton),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Pitch, Roll, Slope, Roof Pitch Grid
          Row(
            children: [
              Expanded(
                child: _TelemetryBox(
                  title: s.livePitchLabel,
                  value: '${calibratedPitch.toStringAsFixed(1)}°',
                  accent: AppTheme.accentGreen,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TelemetryBox(
                  title: s.rollAxisLabel,
                  value: '${calibratedRoll.toStringAsFixed(1)}°',
                  accent: AppTheme.accentCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TelemetryBox(
                  title: s.slopePercentLabel,
                  value: '${slopePct.toStringAsFixed(1)} %',
                  accent: AppTheme.accentAmber,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TelemetryBox(
                  title: s.roofPitchLabel,
                  value: '${roofRise.toStringAsFixed(1)} : 12',
                  accent: AppTheme.accentGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TelemetryBox(
                  title: s.azimuthLabel,
                  value: '${widget.currentSnapshot.azimuth.toStringAsFixed(0)}°',
                  accent: AppTheme.accentCyan,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TelemetryBox(
                  title: s.barometerLabel,
                  value:
                      '${widget.currentSnapshot.pressureHpa.toStringAsFixed(1)} hPa (${baroAlt}m)',
                  accent: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Manual Pitch & Roll Simulation Sliders
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.simulationModeTitle,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Pitch: ${widget.currentSnapshot.pitch.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Slider(
                    key: const Key('sliderClinometerPitch'),
                    value: widget.currentSnapshot.pitch.clamp(-60.0, 60.0),
                    min: -60.0,
                    max: 60.0,
                    onChanged: (v) {
                      widget.sensorService.setManualOverride(true);
                      widget.sensorService.setManualAngles(pitch: v);
                      widget.onRefreshSensor();
                    },
                  ),
                  Text(
                    'Roll: ${widget.currentSnapshot.roll.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Slider(
                    key: const Key('sliderClinometerRoll'),
                    value: widget.currentSnapshot.roll.clamp(-60.0, 60.0),
                    min: -60.0,
                    max: 60.0,
                    onChanged: (v) {
                      widget.sensorService.setManualOverride(true);
                      widget.sensorService.setManualAngles(roll: v);
                      widget.onRefreshSensor();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TelemetryBox extends StatelessWidget {
  final String title;
  final String value;
  final Color accent;

  const _TelemetryBox({
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surfaceSlate,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _BullseyeLevelPainter extends CustomPainter {
  final double pitchDeg;
  final double rollDeg;
  final bool isLevel;

  const _BullseyeLevelPainter({
    required this.pitchDeg,
    required this.rollDeg,
    required this.isLevel,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxR = size.width / 2 - 14;

    final ringPaint = Paint()
      ..color = const Color(0xFF94A3B8).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawCircle(center, maxR, ringPaint);
    canvas.drawCircle(center, maxR * 0.65, ringPaint);
    canvas.drawCircle(center, maxR * 0.3, ringPaint);

    // Cross axes
    canvas.drawLine(
      Offset(center.dx - maxR, center.dy),
      Offset(center.dx + maxR, center.dy),
      ringPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - maxR),
      Offset(center.dx, center.dy + maxR),
      ringPaint,
    );

    // Bubble position mapped from roll (X) and pitch (Y)
    final normX = (rollDeg / 45.0).clamp(-1.0, 1.0);
    final normY = (-pitchDeg / 45.0).clamp(-1.0, 1.0);
    final bubbleOffset = Offset(
      center.dx + normX * (maxR - 18),
      center.dy + normY * (maxR - 18),
    );

    final bubbleColor =
        isLevel ? const Color(0xFF00E676) : const Color(0xFFFFB300);

    canvas.drawCircle(
      bubbleOffset,
      16,
      Paint()
        ..color = bubbleColor.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      bubbleOffset,
      10,
      Paint()
        ..color = bubbleColor
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _BullseyeLevelPainter oldDelegate) {
    return oldDelegate.pitchDeg != pitchDeg ||
        oldDelegate.rollDeg != rollDeg ||
        oldDelegate.isLevel != isLevel;
  }
}
