import 'dart:math' as math;

/// Physical stiffness, damping, and mass coefficients matching exact
/// `react_liquid_gooey` physics specifications.
class SpringParameters {
  final double stiffness;
  final double damping;
  final double mass;

  const SpringParameters({
    required this.stiffness,
    required this.damping,
    this.mass = 1.0,
  });

  /// Damping ratio derived from a normalized 0..1 bounciness knob.
  static double calculateZeta(double bounce) {
    return math.max(0.12, 1.0 - 1.1 * bounce.clamp(0.0, 1.0));
  }

  /// Scales damping and stiffness according to speed and bounce ratio.
  factory SpringParameters.fromFeel({
    required double baseStiffness,
    required double baseDamping,
    double speed = 1.0,
    double bounce = 0.5,
  }) {
    final s = math.max(0.25, speed);
    final k = calculateZeta(bounce) / calculateZeta(0.5);
    return SpringParameters(
      stiffness: baseStiffness * s * s,
      damping: baseDamping * s * k,
    );
  }

  /// Mass centre spring matching `EVOLVE_DEFAULTS` (320 / 17).
  static const SpringParameters defaultMass = SpringParameters(
    stiffness: 320.0,
    damping: 17.0,
  );

  /// Width / Height jelly size spring matching `EVOLVE_DEFAULTS` (170 / 11.5).
  static const SpringParameters defaultSize = SpringParameters(
    stiffness: 170.0,
    damping: 11.5,
  );

  /// Corner radius spring matching `EVOLVE_DEFAULTS` (900 / 60) — critically damped.
  static const SpringParameters defaultRadius = SpringParameters(
    stiffness: 900.0,
    damping: 60.0,
  );

  /// Movement spring matching `MOVE_DEFAULTS` (380 / 18).
  static const SpringParameters defaultMove = SpringParameters(
    stiffness: 380.0,
    damping: 18.0,
  );

  /// Tail tracking spring (170 / 22).
  static const SpringParameters defaultTail = SpringParameters(
    stiffness: 170.0,
    damping: 22.0,
  );
}
