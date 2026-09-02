import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/corner_radii.dart';

/// Instantaneous frame state of an animated liquid body.
@immutable
class LiquidSimState {
  final Offset center;
  final Offset velocity;
  final Size size;
  final CornerRadii radii;
  final Offset leadOffset;
  final Offset satelliteOffset;
  final double satelliteRadius;
  final double bendVertical;
  final double bendHorizontal;
  final double scaleX;
  final double scaleY;
  final bool isSettled;

  const LiquidSimState({
    required this.center,
    required this.velocity,
    required this.size,
    required this.radii,
    this.leadOffset = Offset.zero,
    this.satelliteOffset = Offset.zero,
    this.satelliteRadius = 0.0,
    this.bendVertical = 0.0,
    this.bendHorizontal = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.isSettled = true,
  });

  static const LiquidSimState zero = LiquidSimState(
    center: Offset.zero,
    velocity: Offset.zero,
    size: Size.zero,
    radii: CornerRadii.zero,
    isSettled: true,
  );

  LiquidSimState copyWith({
    Offset? center,
    Offset? velocity,
    Size? size,
    CornerRadii? radii,
    Offset? leadOffset,
    Offset? satelliteOffset,
    double? satelliteRadius,
    double? bendVertical,
    double? bendHorizontal,
    double? scaleX,
    double? scaleY,
    bool? isSettled,
  }) {
    return LiquidSimState(
      center: center ?? this.center,
      velocity: velocity ?? this.velocity,
      size: size ?? this.size,
      radii: radii ?? this.radii,
      leadOffset: leadOffset ?? this.leadOffset,
      satelliteOffset: satelliteOffset ?? this.satelliteOffset,
      satelliteRadius: satelliteRadius ?? this.satelliteRadius,
      bendVertical: bendVertical ?? this.bendVertical,
      bendHorizontal: bendHorizontal ?? this.bendHorizontal,
      scaleX: scaleX ?? this.scaleX,
      scaleY: scaleY ?? this.scaleY,
      isSettled: isSettled ?? this.isSettled,
    );
  }
}
