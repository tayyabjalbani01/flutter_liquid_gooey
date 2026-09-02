import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/blob_box.dart';

/// Scoped context for registering liquid elements with parent [LiquidGooeyGroup].
class LiquidItemRegistration extends InheritedWidget {
  final void Function(String id, BlobBox box) onUpdate;
  final void Function(String id) onUnregister;
  final Color fillColor;

  /// A [GlobalKey] pointing to the root widget of the [LiquidGooeyGroup].
  /// Used by child [LiquidItem] widgets to resolve their position relative
  /// to the group coordinate space via [RenderBox.localToGlobal].
  final GlobalKey groupKey;

  const LiquidItemRegistration({
    super.key,
    required this.onUpdate,
    required this.onUnregister,
    required this.fillColor,
    required this.groupKey,
    required super.child,
  });

  static LiquidItemRegistration? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LiquidItemRegistration>();
  }

  @override
  bool updateShouldNotify(covariant LiquidItemRegistration oldWidget) {
    return oldWidget.fillColor != fillColor ||
        oldWidget.groupKey != oldWidget.groupKey;
  }
}

