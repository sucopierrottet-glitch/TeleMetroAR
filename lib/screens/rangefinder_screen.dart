import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../calculators/telemetro_calculator.dart';
import '../l10n/app_strings.dart';
import '../models/measurement_record.dart';
import '../services/sensor_service.dart';
import '../theme/app_theme.dart';

class RangefinderScreen extends StatefulWidget {
  final AppStrings strings;
  final SensorService sensorService;
  final SensorSnapshot currentSnapshot;
  final double eyeHeightMeters;
  final ValueChanged<double> onEyeHeightChanged;
  final ValueChanged<MeasurementRecord> onSaveMeasurement;
  final VoidCallback onRefreshSensor;

  const RangefinderScreen({
    super.key,
    required this.strings,
    required this.sensorService,
    required this.currentSnapshot,
    required this.eyeHeightMeters,
    required this.onEyeHeightChanged,
    required this.onSaveMeasurement,
    required this.onRefreshSensor,
  });

  @override
  State<RangefinderScreen> createState() => _RangefinderScreenState();
}

class _RangefinderScreenState extends State<RangefinderScreen> {
  double _lockedBaseAngle = -18.5;
  double _lockedTopAngle = 28.0;

  void _lockBaseAngle() {
    setState(() {
      final live = widget.currentSnapshot.pitch;
      // Ensure non-zero angle for base distance calculation
      _lockedBaseAngle = live.abs() < 0.8 ? -12.0 : live;
    });
  }

  void _lockTopAngle() {
    setState(() {
      _lockedTopAngle = widget.currentSnapshot.pitch;
    });
  }

  void _resetAngles() {
    setState(() {
      _lockedBaseAngle = -18.5;
      _lockedTopAngle = 28.0;
      widget.sensorService.setManualAngles(pitch: -18.5);
    });
    widget.onRefreshSensor();
  }

  void _saveCurrentResult(TelemetroResult calc) {
    final id = const Uuid().v4().substring(0, 8).toUpperCase();
    final record = MeasurementRecord(
      id: id,
      title: 'PT-$id',
      timestampIso: DateTime.now().toIso8601String(),
      eyeHeightMeters: calc.eyeHeightMeters,
      baseAngleDeg: calc.baseAngleDeg,
      topAngleDeg: calc.topAngleDeg,
      horizontalDistanceMeters: calc.horizontalDistanceMeters,
      targetHeightMeters: calc.targetHeightMeters,
      slopePercent: calc.slopePercent,
      roofPitchRisePer12: calc.roofPitchRisePer12,
      azimuthDeg: widget.currentSnapshot.azimuth,
      pressureHpa: widget.currentSnapshot.pressureHpa,
    );
    widget.onSaveMeasurement(record);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppTheme.surfaceElevated,
        content: Text(
          widget.strings.measurementSavedSnack,
          style: const TextStyle(color: AppTheme.accentGreen),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.strings;
    final livePitch = widget.currentSnapshot.pitch;
    final liveRoll = widget.currentSnapshot.roll;

    final calc = TelemetroCalculator.computeAll(
      eyeHeightMeters: widget.eyeHeightMeters,
      baseAngleDeg: _lockedBaseAngle,
      topAngleDeg: _lockedTopAngle,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Optical HUD Viewfinder with CustomPainter
          Container(
            height: 235,
            decoration: BoxDecoration(
              color: const Color(0xFF070C15),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: AppTheme.accentGreen.withValues(alpha: 0.65),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentGreen.withValues(alpha: 0.08),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _OpticalHudPainter(
                        pitchDeg: livePitch,
                        rollDeg: liveRoll,
                        baseAngleDeg: _lockedBaseAngle,
                        topAngleDeg: _lockedTopAngle,
                        azimuthDeg: widget.currentSnapshot.azimuth,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceSlate.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: Text(
                            widget.currentSnapshot.isHardwareAvailable
                                ? s.hardwareSensorActive
                                : s.simulationModeActive,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.accentGreen,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceSlate.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.borderColor),
                          ),
                          child: Text(
                            'PITCH ${livePitch.toStringAsFixed(1)}° | AZM ${widget.currentSnapshot.azimuth.toStringAsFixed(0)}°',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.accentCyan,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 12,
                    right: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'θ_base: ${_lockedBaseAngle.toStringAsFixed(1)}°',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.accentGreen,
                          ),
                        ),
                        Text(
                          'D = ${calc.horizontalDistanceMeters.toStringAsFixed(2)} m   •   H = ${calc.targetHeightMeters.toStringAsFixed(2)} m',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'θ_top: ${_lockedTopAngle.toStringAsFixed(1)}°',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.accentAmber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Primary Results Grid (D and H)
          Row(
            children: [
              Expanded(
                child: _MetricResultCard(
                  key: const Key('cardHorizontalDistance'),
                  label: s.distanceResultLabel,
                  value: '${calc.horizontalDistanceMeters.toStringAsFixed(2)} m',
                  subValue:
                      'LOS: ${calc.lineOfSightBaseMeters.toStringAsFixed(2)} m',
                  accent: AppTheme.accentGreen,
                  icon: Icons.straighten_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricResultCard(
                  key: const Key('cardTargetHeight'),
                  label: s.heightResultLabel,
                  value: '${calc.targetHeightMeters.toStringAsFixed(2)} m',
                  subValue:
                      'LOS: ${calc.lineOfSightTopMeters.toStringAsFixed(2)} m',
                  accent: AppTheme.accentCyan,
                  icon: Icons.height_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Secondary Metrics Row (Slope %, Roof Pitch, Eye Height)
          Row(
            children: [
              Expanded(
                child: _CompactStatChip(
                  label: s.slopePercentLabel,
                  value: '${calc.slopePercent.toStringAsFixed(1)} %',
                  color: AppTheme.accentAmber,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CompactStatChip(
                  label: s.roofPitchLabel,
                  value: '${calc.roofPitchRisePer12.toStringAsFixed(1)} : 12',
                  color: AppTheme.accentGreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _CompactStatChip(
                  label: s.eyeHeightLabel,
                  value: '${widget.eyeHeightMeters.toStringAsFixed(2)} m',
                  color: AppTheme.accentCyan,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Buttons (Lock Base, Lock Top, Reset, Save)
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('btnLockBase'),
                  onPressed: _lockBaseAngle,
                  icon: const Icon(Icons.vertical_align_bottom_rounded, size: 18),
                  label: Text(s.lockBaseButton),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('btnLockTop'),
                  onPressed: _lockTopAngle,
                  icon: const Icon(Icons.vertical_align_top_rounded, size: 18),
                  label: Text(s.lockTopButton),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filledTonal(
                key: const Key('btnResetAngles'),
                tooltip: s.resetLocksButton,
                onPressed: _resetAngles,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 48,
            child: ElevatedButton.icon(
              key: const Key('btnSaveMeasurement'),
              onPressed: () => _saveCurrentResult(calc),
              icon: const Icon(Icons.bookmark_add_rounded),
              label: Text(s.saveMeasurementButton),
            ),
          ),
          const SizedBox(height: 16),

          // Precision Angle & Eye Height Sliders Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.simulationModeTitle,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Switch(
                        key: const Key('switchManualSim'),
                        value: widget.sensorService.isManualOverride,
                        activeThumbColor: AppTheme.accentGreen,
                        onChanged: (v) {
                          setState(() {
                            widget.sensorService.setManualOverride(v);
                          });
                          widget.onRefreshSensor();
                        },
                      ),
                    ],
                  ),
                  _SliderControlRow(
                    label:
                        '${s.livePitchLabel}: ${livePitch.toStringAsFixed(1)}°',
                    value: livePitch.clamp(-75.0, 75.0),
                    min: -75.0,
                    max: 75.0,
                    onChanged: (v) {
                      widget.sensorService.setManualOverride(true);
                      widget.sensorService.setManualAngles(pitch: v);
                      widget.onRefreshSensor();
                    },
                  ),
                  _SliderControlRow(
                    label:
                        '${s.baseAngleLabel}: ${_lockedBaseAngle.toStringAsFixed(1)}°',
                    value: _lockedBaseAngle.clamp(-80.0, -1.0),
                    min: -80.0,
                    max: -1.0,
                    onChanged: (v) {
                      setState(() {
                        _lockedBaseAngle = v;
                      });
                    },
                  ),
                  _SliderControlRow(
                    label:
                        '${s.topAngleLabel}: ${_lockedTopAngle.toStringAsFixed(1)}°',
                    value: _lockedTopAngle.clamp(-45.0, 80.0),
                    min: -45.0,
                    max: 80.0,
                    onChanged: (v) {
                      setState(() {
                        _lockedTopAngle = v;
                      });
                    },
                  ),
                  _SliderControlRow(
                    label:
                        '${s.eyeHeightLabel}: ${widget.eyeHeightMeters.toStringAsFixed(2)} m',
                    value: widget.eyeHeightMeters.clamp(0.5, 3.0),
                    min: 0.5,
                    max: 3.0,
                    onChanged: widget.onEyeHeightChanged,
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

class _MetricResultCard extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;
  final Color accent;
  final IconData icon;

  const _MetricResultCard({
    super.key,
    required this.label,
    required this.value,
    required this.subValue,
    required this.accent,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceSlate,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: accent),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              color: accent,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            subValue,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactStatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _CompactStatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
      decoration: BoxDecoration(
        color: AppTheme.surfaceSlate,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _SliderControlRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderControlRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _OpticalHudPainter extends CustomPainter {
  final double pitchDeg;
  final double rollDeg;
  final double baseAngleDeg;
  final double topAngleDeg;
  final double azimuthDeg;

  const _OpticalHudPainter({
    required this.pitchDeg,
    required this.rollDeg,
    required this.baseAngleDeg,
    required this.topAngleDeg,
    required this.azimuthDeg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // Subtle tactical radar grid
    final gridPaint = Paint()
      ..color = const Color(0xFF00E676).withValues(alpha: 0.10)
      ..strokeWidth = 1.0;

    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Artificial Horizon tilted by roll and shifted by pitch
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-rollDeg * math.pi / 180.0);

    final pitchOffset = (pitchDeg * 1.6).clamp(-75.0, 75.0);
    final horizonPaint = Paint()
      ..color = const Color(0xFF00E5FF).withValues(alpha: 0.65)
      ..strokeWidth = 1.5;

    canvas.drawLine(
      Offset(-size.width * 0.35, pitchOffset),
      Offset(size.width * 0.35, pitchOffset),
      horizonPaint,
    );

    // Pitch ladder ticks
    for (int deg = -30; deg <= 30; deg += 15) {
      if (deg == 0) continue;
      final y = pitchOffset - deg * 1.4;
      canvas.drawLine(
        Offset(-22, y),
        Offset(22, y),
        horizonPaint..strokeWidth = 1.1,
      );
    }
    canvas.restore();

    // Central Optical Crosshair Reticle
    final reticlePaint = Paint()
      ..color = const Color(0xFF00E676)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    canvas.drawCircle(center, 34, reticlePaint);
    canvas.drawCircle(
      center,
      4,
      Paint()
        ..color = const Color(0xFF00E676)
        ..style = PaintingStyle.fill,
    );

    canvas.drawLine(
      Offset(center.dx - 52, center.dy),
      Offset(center.dx - 14, center.dy),
      reticlePaint,
    );
    canvas.drawLine(
      Offset(center.dx + 14, center.dy),
      Offset(center.dx + 52, center.dy),
      reticlePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - 52),
      Offset(center.dx, center.dy - 14),
      reticlePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 14),
      Offset(center.dx, center.dy + 52),
      reticlePaint,
    );

    // Trigonometric Triangle Preview on the right side of HUD
    final triLeft = size.width * 0.73;
    final triRight = size.width * 0.92;
    final eyeY = size.height * 0.56;
    final groundY = size.height * 0.78;
    final roofY = size.height * 0.25;

    final triPaint = Paint()
      ..color = const Color(0xFFFFB300).withValues(alpha: 0.85)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    // Observer to Base
    canvas.drawLine(Offset(triLeft, eyeY), Offset(triRight, groundY), triPaint);
    // Observer to Top
    canvas.drawLine(Offset(triLeft, eyeY), Offset(triRight, roofY), triPaint);
    // Target vertical structure
    canvas.drawLine(
      Offset(triRight, groundY),
      Offset(triRight, roofY),
      Paint()
        ..color = const Color(0xFF00E676)
        ..strokeWidth = 2.6,
    );
  }

  @override
  bool shouldRepaint(covariant _OpticalHudPainter oldDelegate) {
    return oldDelegate.pitchDeg != pitchDeg ||
        oldDelegate.rollDeg != rollDeg ||
        oldDelegate.baseAngleDeg != baseAngleDeg ||
        oldDelegate.topAngleDeg != topAngleDeg ||
        oldDelegate.azimuthDeg != azimuthDeg;
  }
}
