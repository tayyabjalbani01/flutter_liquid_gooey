import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/flutter_liquid_gooey.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LiquidPhysicsController Tests', () {
    test('initializes with default values matching blob box', () {
      final initial = BlobBox(
        offset: const Offset(50.0, 100.0),
        size: const Size(80.0, 40.0),
        radii: CornerRadii.all(20.0),
      );

      final ctrl = LiquidPhysicsController(initial: initial);
      expect(ctrl.value.center, const Offset(90.0, 120.0));
      expect(ctrl.value.size, const Size(80.0, 40.0));
      expect(ctrl.value.scaleX, 1.0);
      expect(ctrl.value.scaleY, 1.0);
      ctrl.dispose();
    });

    test('setPressed alters target scale and injects velocity impulses', () {
      final initial = BlobBox(
        offset: Offset.zero,
        size: const Size(60.0, 60.0),
        radii: CornerRadii.all(16.0),
      );

      final ctrl = LiquidPhysicsController(initial: initial);
      ctrl.setPressed(true);
      expect(ctrl.scaleX.target, 1.05);
      expect(ctrl.scaleY.target, 1.06);
      expect(ctrl.scaleX.velocity, -2.2);
      expect(ctrl.scaleY.velocity, 2.6);

      ctrl.setPressed(false);
      expect(ctrl.scaleX.target, 1.0);
      expect(ctrl.scaleY.target, 1.0);
      ctrl.dispose();
    });

    test('advance steps all Euler spring integrators smoothly', () {
      final initial = BlobBox(
        offset: Offset.zero,
        size: const Size(50.0, 50.0),
        radii: CornerRadii.all(10.0),
      );

      final ctrl = LiquidPhysicsController(initial: initial);
      ctrl.updateTarget(BlobBox(
        offset: const Offset(100.0, 100.0),
        size: const Size(80.0, 80.0),
        radii: CornerRadii.all(20.0),
      ));

      ctrl.advance(1.0 / 60.0);
      expect(ctrl.value.center.dx, greaterThan(25.0));
      expect(ctrl.value.size.width, greaterThan(50.0));
      ctrl.dispose();
    });
  });
}
