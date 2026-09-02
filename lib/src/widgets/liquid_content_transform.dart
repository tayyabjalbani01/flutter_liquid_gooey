import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/physics/liquid_sim_state.dart';

/// Applies synchronized liquid motion deform and velocity blur to child widgets.
class LiquidContentTransform extends StatelessWidget {
  final LiquidSimState state;
  final bool enableMotionBlur;
  final Widget child;

  const LiquidContentTransform({
    super.key,
    required this.state,
    required this.child,
    this.enableMotionBlur = false,
  });

  @override
  Widget build(BuildContext context) {
    final tilt = (state.velocity.dx * 0.00035).clamp(-0.08, 0.08);

    Widget content = Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..translateByDouble(
          -state.bendHorizontal * 0.35,
          state.bendVertical * 0.35,
          0.0,
          1.0,
        )
        ..rotateZ(tilt)
        ..scaleByDouble(state.scaleX, state.scaleY, 1.0, 1.0),
      child: child,
    );

    if (enableMotionBlur) {
      final blur = math.min(2.5, state.velocity.distance * 0.004);
      if (blur > 0.4) {
        content = ImageFiltered(
          imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: content,
        );
      }
    }

    return content;
  }
}
