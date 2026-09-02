import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/blob_box.dart';
import 'package:flutter_liquid_gooey/src/models/corner_radii.dart';
import 'package:flutter_liquid_gooey/src/models/liquid_effect.dart';
import 'package:flutter_liquid_gooey/src/models/shadow_layer.dart';
import 'package:flutter_liquid_gooey/src/physics/liquid_physics_controller.dart';
import 'package:flutter_liquid_gooey/src/rendering/liquid_vector_painter.dart';
import 'package:flutter_liquid_gooey/src/widgets/liquid_content_transform.dart';
import 'package:flutter_liquid_gooey/src/widgets/liquid_item_registration.dart';
import 'package:flutter_liquid_gooey/src/widgets/liquid_registration_coordinator.dart';

/// Interactive liquid element participating in gooey fluid physics.
class LiquidItem extends StatefulWidget {
  final Widget child;
  final LiquidEffect effect;
  final double radius;
  final Color? color;
  final Offset? position;
  final bool? isPressed;
  final bool enableMotionBlur;
  final VoidCallback? onTap;

  const LiquidItem({
    super.key,
    required this.child,
    this.effect = LiquidEffect.morph,
    this.radius = 16.0,
    this.color,
    this.position,
    this.isPressed,
    this.enableMotionBlur = false,
    this.onTap,
  });

  @override
  State<LiquidItem> createState() => _LiquidItemState();
}

class _LiquidItemState extends State<LiquidItem> with SingleTickerProviderStateMixin {
  late final LiquidPhysicsController _controller;
  late final Ticker _ticker;
  Duration _lastElapsed = Duration.zero;
  final String _id = UniqueKey().toString();
  final GlobalKey _itemKey = GlobalKey();
  LiquidItemRegistration? _reg;

  @override
  void initState() {
    super.initState();
    _controller = LiquidPhysicsController(
      initial: BlobBox(
        offset: widget.position ?? Offset.zero,
        size: const Size(64.0, 64.0),
        radii: CornerRadii.all(widget.radius),
      ),
      effect: widget.effect,
    );
    if (widget.isPressed != null) _controller.setPressed(widget.isPressed!);
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reg = LiquidItemRegistration.of(context);
  }

  @override
  void didUpdateWidget(covariant LiquidItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != null && widget.position != oldWidget.position) {
      final box = _itemKey.currentContext?.findRenderObject();
      final size = (box is RenderBox && box.hasSize) ? box.size : const Size(64.0, 64.0);
      _controller.updateTarget(BlobBox(
        offset: widget.position!,
        size: size,
        radii: CornerRadii.all(widget.radius),
      ));
    }
    if (widget.isPressed != null && widget.isPressed != oldWidget.isPressed) {
      _controller.setPressed(widget.isPressed!);
    }
  }

  @override
  void dispose() {
    _reg?.onUnregister(_id);
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;
    if (dt > 0.0 && dt < 0.1) _controller.advance(dt);
    LiquidRegistrationCoordinator.refresh(
      id: _id,
      radius: widget.radius,
      itemKey: _itemKey,
      registration: _reg,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget interactive = Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _controller.setPressed(true),
      onPointerUp: (_) => _controller.setPressed(false),
      onPointerCancel: (_) => _controller.setPressed(false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => LiquidContentTransform(
          state: _controller.value,
          enableMotionBlur: widget.enableMotionBlur,
          child: child!,
        ),
        child: widget.child,
      ),
    );

    if (widget.onTap != null) {
      interactive = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: interactive,
      );
    }

    if (_reg != null) return KeyedSubtree(key: _itemKey, child: interactive);

    return RepaintBoundary(
      key: _itemKey,
      child: CustomPaint(
        painter: LiquidVectorPainter(
          state: _controller,
          fillColor: widget.color ?? const Color(0xFFFFFFFF),
          shadows: const [
            ShadowLayer(offset: Offset(0.0, 3.0), blur: 10.0, color: Color(0x10000000)),
            ShadowLayer(offset: Offset(0.0, 1.0), blur: 2.0, color: Color(0x06000000)),
          ],
        ),
        child: interactive,
      ),
    );
  }
}
