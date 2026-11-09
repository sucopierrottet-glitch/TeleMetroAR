import 'dart:math' as math;

class TelemetroResult {
  final double eyeHeightMeters;
  final double baseAngleDeg;
  final double topAngleDeg;
  final double horizontalDistanceMeters;
  final double targetHeightMeters;
  final double lineOfSightBaseMeters;
  final double lineOfSightTopMeters;
  final double slopePercent;
  final double roofPitchRisePer12;

  const TelemetroResult({
    required this.eyeHeightMeters,
    required this.baseAngleDeg,
    required this.topAngleDeg,
    required this.horizontalDistanceMeters,
    required this.targetHeightMeters,
    required this.lineOfSightBaseMeters,
    required this.lineOfSightTopMeters,
    required this.slopePercent,
    required this.roofPitchRisePer12,
  });
}

class TelemetroCalculator {
  /// Converts degrees to radians.
  static double degToRad(double degrees) => degrees * (math.pi / 180.0);

  /// Converts radians to degrees.
  static double radToDeg(double radians) => radians * (180.0 / math.pi);

  /// Trigonometric horizontal distance:
  /// D = h_eye / tan(|theta_base|)
  /// Clamps |theta_base| to [0.5°, 89.5°] to prevent division by zero or infinity.
  static double calculateHorizontalDistance({
    required double eyeHeightMeters,
    required double baseAngleDeg,
  }) {
    final safeEyeHeight = eyeHeightMeters.clamp(0.1, 50.0);
    final absTheta = baseAngleDeg.abs().clamp(0.5, 89.5);
    final rad = degToRad(absTheta);
    final distance = safeEyeHeight / math.tan(rad);
    return double.parse(distance.toStringAsFixed(3));
  }

  /// Target total height:
  /// H = h_eye + D * tan(theta_top)
  /// Works whether theta_top is above horizon (> 0) or below horizon (< 0).
  static double calculateTargetHeight({
    required double eyeHeightMeters,
    required double horizontalDistanceMeters,
    required double topAngleDeg,
  }) {
    final safeEyeHeight = eyeHeightMeters.clamp(0.1, 50.0);
    final clampedTop = topAngleDeg.clamp(-88.0, 88.0);
    final rad = degToRad(clampedTop);
    final height = safeEyeHeight + (horizontalDistanceMeters * math.tan(rad));
    return double.parse(math.max(0.0, height).toStringAsFixed(3));
  }

  /// Direct line-of-sight (hypotenuse) distance to the target base:
  /// LOS_base = D / cos(|theta_base|)
  static double calculateLineOfSightBase({
    required double horizontalDistanceMeters,
    required double baseAngleDeg,
  }) {
    final absTheta = baseAngleDeg.abs().clamp(0.5, 89.5);
    final los = horizontalDistanceMeters / math.cos(degToRad(absTheta));
    return double.parse(los.toStringAsFixed(3));
  }

  /// Direct line-of-sight (hypotenuse) distance to the target top:
  /// LOS_top = D / cos(|theta_top|)
  static double calculateLineOfSightTop({
    required double horizontalDistanceMeters,
    required double topAngleDeg,
  }) {
    final absTop = topAngleDeg.abs().clamp(0.0, 88.0);
    final los = horizontalDistanceMeters / math.cos(degToRad(absTop));
    return double.parse(los.toStringAsFixed(3));
  }

  /// Slope percentage from inclination angle in degrees:
  /// Slope % = tan(theta) * 100
  static double calculateSlopePercent(double angleDeg) {
    final clamped = angleDeg.clamp(-88.0, 88.0);
    final slope = math.tan(degToRad(clamped)) * 100.0;
    return double.parse(slope.toStringAsFixed(2));
  }

  /// Roof pitch rise per 12 units of horizontal run (X:12):
  /// Rise = |tan(theta)| * 12
  static double calculateRoofPitchRise(double angleDeg) {
    final clamped = angleDeg.abs().clamp(0.0, 85.0);
    final rise = math.tan(degToRad(clamped)) * 12.0;
    return double.parse(rise.toStringAsFixed(2));
  }

  /// Barometric relative altitude estimation (hypsometric approximation):
  /// h = 44330 * (1 - (P / P0)^(1/5.255))
  static double calculateBarometricAltitude(
    double pressureHpa, {
    double seaLevelHpa = 1013.25,
  }) {
    if (pressureHpa <= 0 || seaLevelHpa <= 0) return 0.0;
    final ratio = pressureHpa / seaLevelHpa;
    final alt = 44330.0 * (1.0 - math.pow(ratio, 1.0 / 5.255));
    return double.parse(alt.toStringAsFixed(1));
  }

  /// Full trigonometric computation bundle.
  static TelemetroResult computeAll({
    required double eyeHeightMeters,
    required double baseAngleDeg,
    required double topAngleDeg,
  }) {
    final d = calculateHorizontalDistance(
      eyeHeightMeters: eyeHeightMeters,
      baseAngleDeg: baseAngleDeg,
    );
    final h = calculateTargetHeight(
      eyeHeightMeters: eyeHeightMeters,
      horizontalDistanceMeters: d,
      topAngleDeg: topAngleDeg,
    );
    final losBase = calculateLineOfSightBase(
      horizontalDistanceMeters: d,
      baseAngleDeg: baseAngleDeg,
    );
    final losTop = calculateLineOfSightTop(
      horizontalDistanceMeters: d,
      topAngleDeg: topAngleDeg,
    );
    final slope = calculateSlopePercent(topAngleDeg);
    final roofRise = calculateRoofPitchRise(topAngleDeg);

    return TelemetroResult(
      eyeHeightMeters: eyeHeightMeters,
      baseAngleDeg: baseAngleDeg,
      topAngleDeg: topAngleDeg,
      horizontalDistanceMeters: d,
      targetHeightMeters: h,
      lineOfSightBaseMeters: losBase,
      lineOfSightTopMeters: losTop,
      slopePercent: slope,
      roofPitchRisePer12: roofRise,
    );
  }
}
