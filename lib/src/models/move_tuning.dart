import 'package:flutter/foundation.dart';

/// Tuning parameters for `LiquidEffect.move`.
@immutable
class MoveTuning {
  /// How tightly the liquid surface chases the moving element (0.0 to 1.0).
  final double springiness;

  /// Wobble and overshoot oscillation upon arrival (0.0 to 1.0).
  final double wobble;

  /// Axial elongation under velocity (0.0 = rigid).
  final double stretch;

  /// Trailing satellite droplet size factor (0.0 = disabled).
  final double trail;

  /// Reach of the trailing satellite tongue (0.0 to 1.0).
  final double force;

  const MoveTuning({
    this.springiness = 0.5,
    this.wobble = 0.5,
    this.stretch = 0.36,
    this.trail = 0.575,
    this.force = 0.5,
  });

  static const MoveTuning defaults = MoveTuning();
}
