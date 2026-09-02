import 'package:flutter/foundation.dart';

/// Tuning parameters for `LiquidEffect.morph`.
@immutable
class MorphTuning {
  /// Whether liquid springs lag behind size/shape changes.
  final bool shape;

  /// Speed multiplier for shape physics (1.0 = standard tempo).
  final double speed;

  /// Bounciness ratio (0.0 = critically damped, 1.0 = springy jelly).
  final double bounce;

  /// Max content cross-blur in px during fast morphs (0.0 = disabled).
  final double contentBlur;

  /// Silhouette shrinkage per side for opaque content (e.g. photos).
  final double blobInset;

  /// Silhouette expansion px when near a neighbour to form liquid bridges.
  final double bridgeGrow;

  const MorphTuning({
    this.shape = true,
    this.speed = 1.0,
    this.bounce = 0.5,
    this.contentBlur = 6.0,
    this.blobInset = 0.0,
    this.bridgeGrow = 0.0,
  });

  static const MorphTuning defaults = MorphTuning();
}
