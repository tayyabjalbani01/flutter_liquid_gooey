import 'dart:math' as math;
import 'package:flutter_liquid_gooey/src/physics/spring_parameters.dart';

/// Semi-implicit Euler spring integrator running at fixed sub-steps (240Hz).
class EulerSpringIntegrator {
  static const double fixedDeltaTime = 1.0 / 240.0;
  static const double positionEpsilon = 0.001;
  static const double velocityEpsilon = 0.01;

  double value;
  double velocity;
  double target;
  SpringParameters params;

  EulerSpringIntegrator({
    required this.value,
    this.velocity = 0.0,
    required this.target,
    required this.params,
  });

  /// Steps the simulation by [elapsedSeconds] using fixed sub-steps.
  void step(double elapsedSeconds) {
    var remaining = math.min(elapsedSeconds, 0.1);
    while (remaining > 0.0) {
      final dt = remaining > fixedDeltaTime ? fixedDeltaTime : remaining;
      remaining -= dt;

      final displacement = value - target;
      final springForce = -params.stiffness * displacement;
      final dampingForce = -params.damping * velocity;
      final acceleration = (springForce + dampingForce) / params.mass;

      velocity += acceleration * dt;
      value += velocity * dt;
    }
  }

  /// Whether the spring has settled at the target equilibrium.
  bool get isSettled =>
      (value - target).abs() < positionEpsilon &&
      velocity.abs() < velocityEpsilon;

  /// Snaps value and velocity directly to target.
  void snapTo(double newTarget) {
    target = newTarget;
    value = newTarget;
    velocity = 0.0;
  }
}
