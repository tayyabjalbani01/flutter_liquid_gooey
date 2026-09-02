import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/shadow_layer.dart';
import 'package:flutter_liquid_gooey/src/physics/liquid_sim_state.dart';
import 'package:flutter_liquid_gooey/src/rendering/liquid_vector_geometry.dart';

/// High-performance [CustomPainter] for liquid vector deformations with subtle shadows and borders.
class LiquidVectorPainter extends CustomPainter {
  final ValueListenable<LiquidSimState> state;
  final Color fillColor;
  final List<ShadowLayer> shadows;

  final Paint _fillPaint = Paint()..style = PaintingStyle.fill;
  final Paint _shadowPaint = Paint()..style = PaintingStyle.fill;
  final Paint _strokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.8
    ..color = const Color(0x0C000000);

  LiquidVectorPainter({
    required this.state,
    this.fillColor = const Color(0xFFFFFFFF),
    this.shadows = const [],
  }) : super(repaint: state) {
    _fillPaint.color = fillColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final s = state.value;

    final w = size.width > 0 ? size.width : s.size.width;
    final h = size.height > 0 ? size.height : s.size.height;
    if (w <= 0 || h <= 0) return;

    final localCenter = Offset(w * 0.5, h * 0.5);
    final rect = Rect.fromCenter(center: localCenter, width: w, height: h);

    final path = LiquidVectorGeometry.buildBodyPath(
      rect: rect,
      radius: s.radii.topLeft,
      verticalBow: s.bendVertical,
      horizontalCapStretch: s.bendHorizontal,
    );

    final speed = s.velocity.distance;
    final hasMotion = speed > 2.0;

    canvas.save();
    canvas.translate(localCenter.dx, localCenter.dy);
    canvas.scale(s.scaleX, s.scaleY);

    if (hasMotion) {
      final st = math.min(0.18, speed * 0.0006);
      final a = math.atan2(s.velocity.dy, s.velocity.dx);
      canvas.rotate(a);
      canvas.scale(1.0 + st, 1.0 / (1.0 + st * 0.65));
      canvas.rotate(-a);
    }
    canvas.translate(-localCenter.dx, -localCenter.dy);

    for (final shadow in shadows) {
      if (!shadow.inset && shadow.color.a > 0) {
        _shadowPaint.color = shadow.color;
        _shadowPaint.maskFilter = shadow.blur > 0
            ? MaskFilter.blur(BlurStyle.normal, shadow.blur * 0.5)
            : null;
        canvas.save();
        canvas.translate(shadow.dx, shadow.dy);
        canvas.drawPath(path, _shadowPaint);
        canvas.restore();
      }
    }

    canvas.drawPath(path, _fillPaint);
    canvas.drawPath(path, _strokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LiquidVectorPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor || oldDelegate.shadows != shadows;
}
