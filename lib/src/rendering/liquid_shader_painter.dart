import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/blob_box.dart';

/// GPU-accelerated [CustomPainter] executing SDF smooth-min fragment shaders.
/// Supports up to 4 blobs. Unused slots are parked at (−9999, −9999) so their
/// SDFs do not influence the merge.
class LiquidShaderPainter extends CustomPainter {
  final ui.FragmentShader shader;
  final ValueListenable<List<BlobBox>> blobs;
  final double gooStrength;
  final double waviness;
  final double time;
  final Color fillColor;
  final Color innerColor;
  final double innerSpread;
  final Paint _shaderPaint = Paint();

  static const BlobBox _parked = BlobBox(
    offset: Offset(-9999.0, -9999.0),
    size: Size.zero,
  );

  LiquidShaderPainter({
    required this.shader,
    required this.blobs,
    this.gooStrength = 24.0,
    this.waviness = 0.0,
    this.time = 0.0,
    this.fillColor = const Color(0xFFFFFFFF),
    this.innerColor = const Color(0x33FFFFFF),
    this.innerSpread = 4.0,
  }) : super(repaint: blobs);

  @override
  void paint(Canvas canvas, Size size) {
    final list = blobs.value;
    if (list.isEmpty) return;

    final b0 = list[0];
    final b1 = list.length > 1 ? list[1] : _parked;
    final b2 = list.length > 2 ? list[2] : _parked;
    final b3 = list.length > 3 ? list[3] : _parked;

    // --- uResolution ---
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);

    // --- uBlob0: left, top, width, height ---
    shader.setFloat(2, b0.x);
    shader.setFloat(3, b0.y);
    shader.setFloat(4, b0.width);
    shader.setFloat(5, b0.height);

    // --- uBlob1 ---
    shader.setFloat(6, b1.x);
    shader.setFloat(7, b1.y);
    shader.setFloat(8, b1.width);
    shader.setFloat(9, b1.height);

    // --- uBlob2 ---
    shader.setFloat(10, b2.x);
    shader.setFloat(11, b2.y);
    shader.setFloat(12, b2.width);
    shader.setFloat(13, b2.height);

    // --- uBlob3 ---
    shader.setFloat(14, b3.x);
    shader.setFloat(15, b3.y);
    shader.setFloat(16, b3.width);
    shader.setFloat(17, b3.height);

    // --- Corner radii ---
    shader.setFloat(18, b0.radii.topLeft);
    shader.setFloat(19, b1.radii.topLeft);
    shader.setFloat(20, b2.radii.topLeft);
    shader.setFloat(21, b3.radii.topLeft);

    // --- Effect params ---
    shader.setFloat(22, gooStrength);
    shader.setFloat(23, waviness);
    shader.setFloat(24, time);

    // --- Fill Color ---
    shader.setFloat(25, fillColor.r);
    shader.setFloat(26, fillColor.g);
    shader.setFloat(27, fillColor.b);
    shader.setFloat(28, fillColor.a);

    // --- Inner Color ---
    shader.setFloat(29, innerColor.r);
    shader.setFloat(30, innerColor.g);
    shader.setFloat(31, innerColor.b);
    shader.setFloat(32, innerColor.a);

    shader.setFloat(33, innerSpread);

    _shaderPaint.shader = shader;
    canvas.drawRect(Offset.zero & size, _shaderPaint);
  }

  @override
  bool shouldRepaint(covariant LiquidShaderPainter oldDelegate) => true;
}
