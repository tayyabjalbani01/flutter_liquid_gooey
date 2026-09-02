import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/blob_box.dart';
import 'package:flutter_liquid_gooey/src/models/corner_radii.dart';
import 'package:flutter_liquid_gooey/src/widgets/liquid_item_registration.dart';

/// Helper coordinating spatial coordinate updates between items and parent groups.
class LiquidRegistrationCoordinator {
  static void refresh({
    required String id,
    required double radius,
    required GlobalKey itemKey,
    required LiquidItemRegistration? registration,
  }) {
    final reg = registration;
    if (reg == null) return;
    final itemCtx = itemKey.currentContext;
    if (itemCtx == null) return;
    final itemBox = itemCtx.findRenderObject();
    if (itemBox is! RenderBox || !itemBox.hasSize || itemBox.size.isEmpty) return;

    final groupCtx = reg.groupKey.currentContext;
    if (groupCtx == null) return;
    final groupBox = groupCtx.findRenderObject();
    if (groupBox is! RenderBox || !groupBox.hasSize) return;

    final itemGlobal = itemBox.localToGlobal(Offset.zero);
    final groupGlobal = groupBox.localToGlobal(Offset.zero);

    reg.onUpdate(id, BlobBox(
      offset: itemGlobal - groupGlobal,
      size: itemBox.size,
      radii: CornerRadii.all(radius),
    ));
  }
}
