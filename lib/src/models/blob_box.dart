import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/corner_radii.dart';

/// Geometry bounding box and corner configuration of a liquid element.
@immutable
class BlobBox {
  final Offset offset;
  final Size size;
  final CornerRadii radii;

  const BlobBox({
    required this.offset,
    required this.size,
    this.radii = CornerRadii.zero,
  });

  double get x => offset.dx;
  double get y => offset.dy;
  double get width => size.width;
  double get height => size.height;
  Offset get center => Offset(x + width * 0.5, y + height * 0.5);

  Rect get rect => offset & size;

  BlobBox copyWith({
    Offset? offset,
    Size? size,
    CornerRadii? radii,
  }) {
    return BlobBox(
      offset: offset ?? this.offset,
      size: size ?? this.size,
      radii: radii ?? this.radii,
    );
  }

  BlobBox lerpTo(BlobBox other, double t) {
    return BlobBox(
      offset: Offset.lerp(offset, other.offset, t)!,
      size: Size.lerp(size, other.size, t)!,
      radii: radii.lerpTo(other.radii, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlobBox &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          size == other.size &&
          radii == other.radii;

  @override
  int get hashCode => Object.hash(offset, size, radii);
}
