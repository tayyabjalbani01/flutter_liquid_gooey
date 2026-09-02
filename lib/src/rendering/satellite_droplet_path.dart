import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Generates trailing satellite droplets with harmonic S-curve weaves.
///
/// Satellites only appear when the body has meaningful velocity (dist threshold)
/// AND the body is using effect=move with an active satellite lag. They are drawn
/// as separate sub-paths using [Path.addOval] so the caller can clip them.
class SatelliteDropletPath {
  /// Minimum pixel distance before satellites are drawn.
  static const double _minDist = 8.0;

  /// Appends trailing droplets to [path] only when [satCenter] has meaningfully
  /// lagged behind [mainCenter]. Returns [true] if any satellite was drawn.
  static bool appendSatellites({
    required Path path,
    required Offset mainCenter,
    required Offset satCenter,
    required double baseRadius,
    required double phase,
  }) {
    if (baseRadius <= 2.0) return false;

    final diff = satCenter - mainCenter;
    final dist = diff.distance;
    if (dist < _minDist) return false;

    // Cap the satellite distance at a reasonable fraction of radius so it never
    // flies far outside the widget bounds and creates ghost artifacts.
    final maxDist = baseRadius * 1.8;
    final clamped = dist > maxDist ? mainCenter + diff * (maxDist / dist) : satCenter;

    final clampedDiff = clamped - mainCenter;
    final clampedDist = clampedDiff.distance;

    final dir = clampedDiff / clampedDist;
    final normal = Offset(-dir.dy, dir.dx);

    // Tail radius scales with distance (further = smaller)
    final rSat = (baseRadius * 0.38 * (1.0 - clampedDist / maxDist * 0.3))
        .clamp(2.0, baseRadius * 0.5);

    // Main lagging satellite
    path.addOval(Rect.fromCircle(center: clamped, radius: rSat));

    // Only add intermediate droplets if there's enough distance
    if (clampedDist > baseRadius * 0.6) {
      final w1 = math.sin(phase) * 0.12 * rSat;
      final c1 = mainCenter + clampedDiff * 0.5 + normal * w1;
      path.addOval(Rect.fromCircle(center: c1, radius: rSat * 0.65));

      if (clampedDist > baseRadius) {
        final w2 = -math.sin(phase + 2.4) * 0.12 * rSat;
        final c2 = mainCenter + clampedDiff * 0.78 + normal * w2;
        path.addOval(Rect.fromCircle(center: c2, radius: rSat * 0.80));
      }
    }
    return true;
  }
}
