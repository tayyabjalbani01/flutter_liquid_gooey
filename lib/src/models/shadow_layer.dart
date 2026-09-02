import 'package:flutter/painting.dart';

/// Inset and outer shadow descriptor rendered on merged liquid silhouettes.
class ShadowLayer {
  final Offset offset;
  final double blur;
  final double spread;
  final Color color;
  final bool inset;

  const ShadowLayer({
    this.offset = Offset.zero,
    this.blur = 0.0,
    this.spread = 0.0,
    this.color = const Color(0x33000000),
    this.inset = false,
  });

  double get dx => offset.dx;
  double get dy => offset.dy;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShadowLayer &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          blur == other.blur &&
          spread == other.spread &&
          color == other.color &&
          inset == other.inset;

  @override
  int get hashCode => Object.hash(offset, blur, spread, color, inset);
}
