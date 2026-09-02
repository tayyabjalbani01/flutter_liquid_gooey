import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Constructs analytical Bezier paths for velocity-bowed liquid shapes.
///
/// Matches the exact SVG path math in react_liquid_gooey/src/observer.ts
/// (the `bendD` path construction block, lines ~1462-1472).
class LiquidVectorGeometry {
  static const double _k = 0.552284749831;

  /// Alias for [buildBodyPath].
  static Path buildBowedPath({
    required Rect rect,
    required double radius,
    required double verticalBow,
    required double horizontalCapStretch,
  }) =>
      buildBodyPath(
        rect: rect,
        radius: radius,
        verticalBow: verticalBow,
        horizontalCapStretch: horizontalCapStretch,
      );

  /// Builds the main body path with full support for rounded pill caps.
  static Path buildBodyPath({
    required Rect rect,
    required double radius,
    required double verticalBow,
    required double horizontalCapStretch,
  }) {
    final w = rect.width;
    final h = rect.height;
    if (w <= 0 || h <= 0) return Path();

    // Clamp radius to at most half the shorter side (guarantees pill capsule)
    final r = math.min(radius, math.min(w, h) * 0.5);

    // At rest: return native RRect — pixel-perfect smooth corners
    if (verticalBow.abs() < 0.5 && horizontalCapStretch.abs() < 0.5) {
      return Path()
        ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(r)));
    }

    final double cy = verticalBow * 2.0;
    final double k = horizontalCapStretch;

    final double rxR = (k > 0 ? r - 0.8 * k : r + 1.6 * -k)
        .clamp(r * 0.2, math.min(w / 2, r * 3.0));
    final double rxL = (k > 0 ? r + 1.6 * k : r - 0.8 * -k)
        .clamp(r * 0.2, math.min(w / 2, r * 3.0));

    final path = Path();
    final l = rect.left;
    final t = rect.top;
    final ri = rect.right;
    final b = rect.bottom;

    path.moveTo(l + rxL, t);
    path.quadraticBezierTo(l + w / 2, t + cy, l + w - rxR, t);

    path.cubicTo(
      l + w - rxR + _k * rxR,
      t,
      ri,
      t + r - _k * r,
      ri,
      t + r,
    );

    path.lineTo(ri, math.max(t + r, b - r));

    path.cubicTo(
      ri,
      b - r + _k * r,
      l + w - rxR + _k * rxR,
      b,
      l + w - rxR,
      b,
    );

    path.quadraticBezierTo(l + w / 2, b + cy, l + rxL, b);

    path.cubicTo(
      l + rxL - _k * rxL,
      b,
      l,
      b - r + _k * r,
      l,
      math.max(t + r, b - r),
    );

    path.lineTo(l, t + r);

    path.cubicTo(
      l,
      t + r - _k * r,
      l + rxL - _k * rxL,
      t,
      l + rxL,
      t,
    );

    path.close();
    return path;
  }
}
