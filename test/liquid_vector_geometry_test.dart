import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_liquid_gooey/flutter_liquid_gooey.dart';

void main() {
  group('LiquidVectorGeometry', () {
    test('buildBowedPath returns non-empty closed path', () {
      final path = LiquidVectorGeometry.buildBowedPath(
        rect: const Rect.fromLTWH(0, 0, 100, 50),
        radius: 12.0,
        verticalBow: 5.0,
        horizontalCapStretch: 2.0,
      );

      final bounds = path.getBounds();
      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('buildBodyPath at rest returns native rounded rect', () {
      final path = LiquidVectorGeometry.buildBodyPath(
        rect: const Rect.fromLTWH(0, 0, 100, 50),
        radius: 12.0,
        verticalBow: 0.0,
        horizontalCapStretch: 0.0,
      );

      final bounds = path.getBounds();
      expect(bounds.width, equals(100));
      expect(bounds.height, equals(50));
    });
  });
}
