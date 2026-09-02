import 'dart:math' as math;
import 'package:flutter/foundation.dart';

/// Immutable 4-corner radii specification with CSS-style overlap clamping.
@immutable
class CornerRadii {
  final double topLeft;
  final double topRight;
  final double bottomRight;
  final double bottomLeft;

  const CornerRadii({
    this.topLeft = 0.0,
    this.topRight = 0.0,
    this.bottomRight = 0.0,
    this.bottomLeft = 0.0,
  });

  const CornerRadii.all(double radius)
      : topLeft = radius,
        topRight = radius,
        bottomRight = radius,
        bottomLeft = radius;

  static const CornerRadii zero = CornerRadii();

  /// Scales radii proportionally if their sum exceeds width or height.
  CornerRadii clampForSize(double width, double height) {
    final tl = math.max(0.0, topLeft);
    final tr = math.max(0.0, topRight);
    final br = math.max(0.0, bottomRight);
    final bl = math.max(0.0, bottomLeft);

    final f = math.min(
      1.0,
      math.min(
        width / math.max(1e-6, tl + tr),
        math.min(
          width / math.max(1e-6, bl + br),
          math.min(
            height / math.max(1e-6, tl + bl),
            height / math.max(1e-6, tr + br),
          ),
        ),
      ),
    );

    return CornerRadii(
      topLeft: tl * f,
      topRight: tr * f,
      bottomRight: br * f,
      bottomLeft: bl * f,
    );
  }

  CornerRadii lerpTo(CornerRadii other, double t) {
    return CornerRadii(
      topLeft: topLeft + (other.topLeft - topLeft) * t,
      topRight: topRight + (other.topRight - topRight) * t,
      bottomRight: bottomRight + (other.bottomRight - bottomRight) * t,
      bottomLeft: bottomLeft + (other.bottomLeft - bottomLeft) * t,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CornerRadii &&
          runtimeType == other.runtimeType &&
          topLeft == other.topLeft &&
          topRight == other.topRight &&
          bottomRight == other.bottomRight &&
          bottomLeft == other.bottomLeft;

  @override
  int get hashCode => Object.hash(topLeft, topRight, bottomRight, bottomLeft);
}
