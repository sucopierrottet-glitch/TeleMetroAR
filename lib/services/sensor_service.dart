import 'dart:async';
import 'package:flutter/services.dart';

class SensorSnapshot {
  final double ax;
  final double ay;
  final double az;
  final double gx;
  final double gy;
  final double gz;
  final double mx;
  final double my;
  final double mz;
  final double magFieldUt;
  final double pressureHpa;
  final double lightLux;
  final double pitch;
  final double roll;
  final double azimuth;
  final bool hasBarometer;
  final bool hasLight;
  final bool hasMag;
  final bool isHardwareAvailable;

  const SensorSnapshot({
    this.ax = 0.0,
    this.ay = 0.0,
    this.az = 9.81,
    this.gx = 0.0,
    this.gy = 0.0,
    this.gz = 0.0,
    this.mx = 0.0,
    this.my = 0.0,
    this.mz = 0.0,
    this.magFieldUt = 46.5,
    this.pressureHpa = 1013.25,
    this.lightLux = 450.0,
    this.pitch = -18.5,
    this.roll = 0.0,
    this.azimuth = 142.0,
    this.hasBarometer = false,
    this.hasLight = false,
    this.hasMag = false,
    this.isHardwareAvailable = false,
  });

  SensorSnapshot copyWith({
    double? pitch,
    double? roll,
    double? azimuth,
    double? pressureHpa,
    double? lightLux,
    double? magFieldUt,
    bool? isHardwareAvailable,
  }) {
    return SensorSnapshot(
      ax: ax,
      ay: ay,
      az: az,
      gx: gx,
      gy: gy,
      gz: gz,
      mx: mx,
      my: my,
      mz: mz,
      magFieldUt: magFieldUt ?? this.magFieldUt,
      pressureHpa: pressureHpa ?? this.pressureHpa,
      lightLux: lightLux ?? this.lightLux,
      pitch: pitch ?? this.pitch,
      roll: roll ?? this.roll,
      azimuth: azimuth ?? this.azimuth,
      hasBarometer: hasBarometer,
      hasLight: hasLight,
      hasMag: hasMag,
      isHardwareAvailable: isHardwareAvailable ?? this.isHardwareAvailable,
    );
  }

  factory SensorSnapshot.fromMap(Map<dynamic, dynamic> map) {
    double toD(dynamic v, double fallback) {
      if (v is num) return v.toDouble();
      return fallback;
    }

    final ax = toD(map['ax'], 0.0);
    final ay = toD(map['ay'], 0.0);
    final az = toD(map['az'], 0.0);
    final hasNonZeroAccel = (ax.abs() + ay.abs() + az.abs()) > 0.05;

    return SensorSnapshot(
      ax: ax,
      ay: ay,
      az: az,
      gx: toD(map['gx'], 0.0),
      gy: toD(map['gy'], 0.0),
      gz: toD(map['gz'], 0.0),
      mx: toD(map['mx'], 0.0),
      my: toD(map['my'], 0.0),
      mz: toD(map['mz'], 0.0),
      magFieldUt: toD(map['magFieldUt'], 46.5),
      pressureHpa: toD(map['pressureHpa'], 1013.25),
      lightLux: toD(map['lightLux'], 450.0),
      pitch: toD(map['pitch'], -18.5),
      roll: toD(map['roll'], 0.0),
      azimuth: toD(map['azimuth'], 142.0),
      hasBarometer: map['hasBarometer'] == true,
      hasLight: map['hasLight'] == true,
      hasMag: map['hasMag'] == true,
      isHardwareAvailable: hasNonZeroAccel,
    );
  }
}

class SensorService {
  static const MethodChannel _channel =
      MethodChannel('com.simpleappspg.sensors/data');

  bool _manualOverride = true;
  double _manualPitch = -18.5;
  double _manualRoll = 0.0;
  double _manualAzimuth = 142.0;

  bool get isManualOverride => _manualOverride;
  double get manualPitch => _manualPitch;
  double get manualRoll => _manualRoll;
  double get manualAzimuth => _manualAzimuth;

  void setManualOverride(bool enabled) {
    _manualOverride = enabled;
  }

  void setManualAngles({double? pitch, double? roll, double? azimuth}) {
    if (pitch != null) _manualPitch = pitch.clamp(-85.0, 85.0);
    if (roll != null) _manualRoll = roll.clamp(-85.0, 85.0);
    if (azimuth != null) _manualAzimuth = azimuth % 360.0;
  }

  Future<SensorSnapshot> getSensorSnapshot() async {
    try {
      final result =
          await _channel.invokeMethod<Map<dynamic, dynamic>>('getSensorSnapshot');
      if (result != null) {
        final hw = SensorSnapshot.fromMap(result);
        if (!_manualOverride && hw.isHardwareAvailable) {
          return hw;
        }
        return hw.copyWith(
          pitch: _manualOverride ? _manualPitch : hw.pitch,
          roll: _manualOverride ? _manualRoll : hw.roll,
          azimuth: _manualOverride ? _manualAzimuth : hw.azimuth,
          isHardwareAvailable: hw.isHardwareAvailable && !_manualOverride,
        );
      }
    } catch (_) {
      // Fallback to simulation snapshot when running in tests or desktop/emulator without channel
    }

    return SensorSnapshot(
      pitch: _manualPitch,
      roll: _manualRoll,
      azimuth: _manualAzimuth,
      isHardwareAvailable: false,
    );
  }
}
