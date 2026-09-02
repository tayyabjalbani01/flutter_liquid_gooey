import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_liquid_gooey/flutter_liquid_gooey.dart';

void main() {
  group('CornerRadii', () {
    test('clampForSize scales down overflowing radii', () {
      const radii = CornerRadii(
        topLeft: 100.0,
        topRight: 100.0,
        bottomRight: 100.0,
        bottomLeft: 100.0,
      );

      final clamped = radii.clampForSize(100.0, 100.0);
      expect(clamped.topLeft, equals(50.0));
      expect(clamped.topRight, equals(50.0));
      expect(clamped.bottomRight, equals(50.0));
      expect(clamped.bottomLeft, equals(50.0));
    });

    test('lerpTo linearly interpolates between radii', () {
      const a = CornerRadii.all(0.0);
      const b = CornerRadii.all(20.0);
      final lerped = a.lerpTo(b, 0.5);

      expect(lerped.topLeft, equals(10.0));
      expect(lerped.topRight, equals(10.0));
      expect(lerped.bottomRight, equals(10.0));
      expect(lerped.bottomLeft, equals(10.0));
    });
  });
}
