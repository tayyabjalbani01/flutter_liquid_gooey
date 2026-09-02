import 'package:flutter/foundation.dart';

/// Tuning parameters for `LiquidEffect.bend`.
@immutable
class BendTuning {
  /// Vertical body bow strength (0.0 to 1.0).
  final double vertical;

  /// Horizontal cap deformation strength (0.0 to 1.0).
  final double horizontal;

  const BendTuning({
    this.vertical = 0.6,
    this.horizontal = 0.35,
  });

  static const BendTuning defaults = BendTuning();
}
