import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/blob_box.dart';
import 'package:flutter_liquid_gooey/src/models/corner_radii.dart';
import 'package:flutter_liquid_gooey/src/models/liquid_effect.dart';
import 'package:flutter_liquid_gooey/src/physics/euler_spring_integrator.dart';
import 'package:flutter_liquid_gooey/src/physics/liquid_sim_state.dart';
import 'package:flutter_liquid_gooey/src/physics/spring_parameters.dart';

/// Drives liquid simulation updates with instant press scale-up and jelly wobble.
class LiquidPhysicsController extends ValueNotifier<LiquidSimState> {
  final LiquidEffect effect;
  final EulerSpringIntegrator posX;
  final EulerSpringIntegrator posY;
  final EulerSpringIntegrator sizeW;
  final EulerSpringIntegrator sizeH;
  final EulerSpringIntegrator radius;
  final EulerSpringIntegrator satX;
  final EulerSpringIntegrator satY;
  final EulerSpringIntegrator scaleX;
  final EulerSpringIntegrator scaleY;

  double _bendCur = 0.0;
  double _bendCurX = 0.0;

  LiquidPhysicsController({
    required BlobBox initial,
    this.effect = LiquidEffect.morph,
  })  : posX = EulerSpringIntegrator(
          value: initial.center.dx,
          target: initial.center.dx,
          params: SpringParameters.defaultMass,
        ),
        posY = EulerSpringIntegrator(
          value: initial.center.dy,
          target: initial.center.dy,
          params: SpringParameters.defaultMass,
        ),
        sizeW = EulerSpringIntegrator(
          value: initial.width,
          target: initial.width,
          params: SpringParameters.defaultSize,
        ),
        sizeH = EulerSpringIntegrator(
          value: initial.height,
          target: initial.height,
          params: SpringParameters.defaultSize,
        ),
        radius = EulerSpringIntegrator(
          value: initial.radii.topLeft,
          target: initial.radii.topLeft,
          params: SpringParameters.defaultRadius,
        ),
        satX = EulerSpringIntegrator(
          value: initial.center.dx,
          target: initial.center.dx,
          params: SpringParameters.defaultTail,
        ),
        satY = EulerSpringIntegrator(
          value: initial.center.dy,
          target: initial.center.dy,
          params: SpringParameters.defaultTail,
        ),
        scaleX = EulerSpringIntegrator(
          value: 1.0,
          target: 1.0,
          params: const SpringParameters(stiffness: 290.0, damping: 16.0),
        ),
        scaleY = EulerSpringIntegrator(
          value: 1.0,
          target: 1.0,
          params: const SpringParameters(stiffness: 260.0, damping: 14.0),
        ),
        super(LiquidSimState(
          center: initial.center,
          velocity: Offset.zero,
          size: initial.size,
          radii: initial.radii,
          isSettled: true,
        ));

  void setPressed(bool isPressed) {
    if (isPressed) {
      scaleX.target = 1.05;
      scaleY.target = 1.06;
      scaleX.velocity = -2.2;
      scaleY.velocity = 2.6;
    } else {
      scaleX.target = 1.0;
      scaleY.target = 1.0;
      scaleX.velocity = 1.2;
      scaleY.velocity = -1.2;
    }
  }

  void updateTarget(BlobBox targetBox) {
    posX.target = targetBox.center.dx;
    posY.target = targetBox.center.dy;
    sizeW.target = targetBox.width;
    sizeH.target = targetBox.height;
    radius.target = targetBox.radii.topLeft;
    satX.target = targetBox.center.dx;
    satY.target = targetBox.center.dy;
  }

  void advance(double dt) {
    posX.step(dt);
    posY.step(dt);
    sizeW.step(dt);
    sizeH.step(dt);
    radius.step(dt);
    satX.step(dt);
    satY.step(dt);
    scaleX.step(dt);
    scaleY.step(dt);

    final vx = posX.velocity;
    final vy = posY.velocity;

    if (effect == LiquidEffect.bend) {
      final capY = math.min(sizeW.value, sizeH.value) * 0.5;
      final capX = math.min(sizeW.value, sizeH.value) * 0.9;
      final bTy = (vy * 0.05).clamp(-capY, capY) * 0.6;
      final bTx = (vx * 0.09).clamp(-capX, capX) * 0.35;
      final factor = math.min(1.0, dt * 9.0);
      _bendCur += (bTy - _bendCur) * factor;
      _bendCurX += (bTx - _bendCurX) * factor;
    }

    value = LiquidSimState(
      center: Offset(posX.value, posY.value),
      velocity: Offset(vx, vy),
      size: Size(math.max(1.0, sizeW.value), math.max(1.0, sizeH.value)),
      radii: CornerRadii.all(math.max(0.0, radius.value)),
      satelliteOffset: Offset(satX.value, satY.value),
      satelliteRadius: 0.0,
      bendVertical: _bendCur,
      bendHorizontal: _bendCurX,
      scaleX: scaleX.value,
      scaleY: scaleY.value,
      isSettled: posX.isSettled && posY.isSettled && scaleX.isSettled && scaleY.isSettled,
    );
  }
}
