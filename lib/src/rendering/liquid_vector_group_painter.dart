import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/blob_box.dart';

/// Vector fallback painter for [LiquidGooeyGroup] when GLSL shaders are unavailable.
class LiquidVectorGroupPainter extends CustomPainter {
  final ValueListenable<List<BlobBox>> blobs;
  final Color fillColor;
  final double gooStrength;

  final Paint _paint = Paint()..style = PaintingStyle.fill;
  final Paint _bridgePaint = Paint()..style = PaintingStyle.fill;

  LiquidVectorGroupPainter({
    required this.blobs,
    required this.fillColor,
    this.gooStrength = 28.0,
  }) : super(repaint: blobs) {
    _paint.color = fillColor;
    _bridgePaint.color = fillColor;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final list = blobs.value;
    if (list.isEmpty) return;

    // Draw individual blob bodies
    for (final b in list) {
      if (b.width <= 0 || b.height <= 0) continue;
      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(b.x, b.y, b.width, b.height),
        Radius.circular(b.radii.topLeft),
      );
      canvas.drawRRect(rrect, _paint);
    }

    // Draw vector gooey bridges between nearby blobs
    if (gooStrength <= 0.5 || list.length < 2) return;
    for (int i = 0; i < list.length; i++) {
      for (int j = i + 1; j < list.length; j++) {
        _drawBridge(canvas, list[i], list[j]);
      }
    }
  }

  void _drawBridge(Canvas canvas, BlobBox a, BlobBox b) {
    final ca = a.center;
    final cb = b.center;
    final dist = (ca - cb).distance;
    final ra = math.min(a.width, a.height) * 0.5;
    final rb = math.min(b.width, b.height) * 0.5;
    final maxDist = (ra + rb) + gooStrength * 1.5;

    if (dist <= 0 || dist > maxDist) return;

    final overlap = (1.0 - (dist - (ra + rb)) / (gooStrength * 1.5)).clamp(0.0, 1.0);
    if (overlap <= 0.01) return;

    final angle = math.atan2(cb.dy - ca.dy, cb.dx - ca.dx);
    final perp = angle + math.pi * 0.5;

    final wa = ra * 0.8 * overlap;
    final wb = rb * 0.8 * overlap;

    final p1 = Offset(ca.dx + math.cos(perp) * wa, ca.dy + math.sin(perp) * wa);
    final p2 = Offset(ca.dx - math.cos(perp) * wa, ca.dy - math.sin(perp) * wa);
    final p3 = Offset(cb.dx - math.cos(perp) * wb, cb.dy - math.sin(perp) * wb);
    final p4 = Offset(cb.dx + math.cos(perp) * wb, cb.dy + math.sin(perp) * wb);

    final mid = (ca + cb) * 0.5;

    final path = Path()
      ..moveTo(p1.dx, p1.dy)
      ..quadraticBezierTo(mid.dx, mid.dy, p4.dx, p4.dy)
      ..lineTo(p3.dx, p3.dy)
      ..quadraticBezierTo(mid.dx, mid.dy, p2.dx, p2.dy)
      ..close();

    canvas.drawPath(path, _bridgePaint);
  }

  @override
  bool shouldRepaint(covariant LiquidVectorGroupPainter oldDelegate) =>
      oldDelegate.fillColor != fillColor || oldDelegate.gooStrength != gooStrength;
}
