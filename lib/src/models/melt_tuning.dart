import 'package:flutter/foundation.dart';

/// Tuning parameters for `LiquidEffect.melt`.
@immutable
class MeltTuning {
  /// Proximity threshold where melting initiates.
  final double range;

  /// Radius of the contact melt zone.
  final double zone;

  /// Multi-texture marbling strength (0.0 to 1.0).
  final double mix;

  /// Pull of melted material toward the contact point.
  final double gravity;

  /// Blur radius of the seam-blending wash.
  final double blur;

  /// Flow speed of procedural fluid churn.
  final double flowSpeed;

  const MeltTuning({
    this.range = 48.0,
    this.zone = 24.0,
    this.mix = 0.7,
    this.gravity = 40.0,
    this.blur = 8.0,
    this.flowSpeed = 22.0,
  });

  static const MeltTuning defaults = MeltTuning();
}
