import 'dart:convert';

class MeasurementRecord {
  final String id;
  final String title;
  final String timestampIso;
  final double eyeHeightMeters;
  final double baseAngleDeg;
  final double topAngleDeg;
  final double horizontalDistanceMeters;
  final double targetHeightMeters;
  final double slopePercent;
  final double roofPitchRisePer12;
  final double azimuthDeg;
  final double pressureHpa;

  const MeasurementRecord({
    required this.id,
    required this.title,
    required this.timestampIso,
    required this.eyeHeightMeters,
    required this.baseAngleDeg,
    required this.topAngleDeg,
    required this.horizontalDistanceMeters,
    required this.targetHeightMeters,
    required this.slopePercent,
    required this.roofPitchRisePer12,
    required this.azimuthDeg,
    required this.pressureHpa,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'timestampIso': timestampIso,
      'eyeHeightMeters': eyeHeightMeters,
      'baseAngleDeg': baseAngleDeg,
      'topAngleDeg': topAngleDeg,
      'horizontalDistanceMeters': horizontalDistanceMeters,
      'targetHeightMeters': targetHeightMeters,
      'slopePercent': slopePercent,
      'roofPitchRisePer12': roofPitchRisePer12,
      'azimuthDeg': azimuthDeg,
      'pressureHpa': pressureHpa,
    };
  }

  factory MeasurementRecord.fromJson(Map<String, dynamic> json) {
    double toD(dynamic v, double fallback) =>
        (v is num) ? v.toDouble() : fallback;

    return MeasurementRecord(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? 'Levantamiento').toString(),
      timestampIso: (json['timestampIso'] ?? '').toString(),
      eyeHeightMeters: toD(json['eyeHeightMeters'], 1.65),
      baseAngleDeg: toD(json['baseAngleDeg'], -18.5),
      topAngleDeg: toD(json['topAngleDeg'], 28.0),
      horizontalDistanceMeters: toD(json['horizontalDistanceMeters'], 4.93),
      targetHeightMeters: toD(json['targetHeightMeters'], 4.27),
      slopePercent: toD(json['slopePercent'], 53.17),
      roofPitchRisePer12: toD(json['roofPitchRisePer12'], 6.38),
      azimuthDeg: toD(json['azimuthDeg'], 142.0),
      pressureHpa: toD(json['pressureHpa'], 1013.25),
    );
  }

  static String encodeList(List<MeasurementRecord> list) {
    return jsonEncode(list.map((e) => e.toJson()).toList());
  }

  static List<MeasurementRecord> decodeList(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .map(MeasurementRecord.fromJson)
            .toList();
      }
    } catch (_) {}
    return [];
  }
}
