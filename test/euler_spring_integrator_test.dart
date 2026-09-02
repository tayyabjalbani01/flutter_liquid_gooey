import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_liquid_gooey/flutter_liquid_gooey.dart';

void main() {
  group('EulerSpringIntegrator', () {
    test('converges smoothly to target equilibrium', () {
      final integrator = EulerSpringIntegrator(
        value: 0.0,
        target: 100.0,
        params: const SpringParameters(stiffness: 300.0, damping: 20.0),
      );

      expect(integrator.isSettled, isFalse);

      // Advance 2 seconds
      for (int i = 0; i < 120; i++) {
        integrator.step(1.0 / 60.0);
      }

      expect(integrator.isSettled, isTrue);
      expect((integrator.value - 100.0).abs(), lessThan(0.01));
    });

    test('snapTo immediately updates target and resets velocity', () {
      final integrator = EulerSpringIntegrator(
        value: 0.0,
        target: 100.0,
        params: SpringParameters.defaultMass,
      );

      integrator.snapTo(50.0);
      expect(integrator.value, equals(50.0));
      expect(integrator.target, equals(50.0));
      expect(integrator.velocity, equals(0.0));
      expect(integrator.isSettled, isTrue);
    });
  });
}
