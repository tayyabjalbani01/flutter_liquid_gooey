import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/widgets/liquid_item.dart';

/// Pre-configured liquid parent with instant touch recoil and merge absorption.
class LiquidParent extends StatefulWidget {
  final Widget child;
  final double radius;
  final Color? color;
  final bool isExpanded;
  final VoidCallback? onTap;

  const LiquidParent({
    super.key,
    required this.child,
    this.radius = 28.0,
    this.color = const Color(0xFFFFFFFF),
    this.isExpanded = false,
    this.onTap,
  });

  @override
  State<LiquidParent> createState() => _LiquidParentState();
}

class _LiquidParentState extends State<LiquidParent>
    with TickerProviderStateMixin {
  late final AnimationController _openWobble;
  late final AnimationController _mergeWobble;

  @override
  void initState() {
    super.initState();
    _openWobble = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
    _mergeWobble = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void didUpdateWidget(covariant LiquidParent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _openWobble.forward(from: 0.0);
      } else {
        _mergeWobble.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _openWobble.dispose();
    _mergeWobble.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (!widget.isExpanded) {
      _openWobble.forward(from: 0.0);
    }
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_openWobble, _mergeWobble]),
      builder: (context, _) {
        final ow = _openWobble.value;
        final oScaleX = -math.sin(ow * math.pi * 2.5) * 0.032 * (1.0 - ow);
        final oScaleY = math.sin(ow * math.pi * 2.5) * 0.022 * (1.0 - ow);

        final mw = _mergeWobble.value;
        final mScaleX = math.sin(mw * math.pi * 2.5) * 0.035 * (1.0 - mw);
        final mScaleY = -math.sin(mw * math.pi * 2.5) * 0.025 * (1.0 - mw);

        return Transform.scale(
          scaleX: 1.0 + oScaleX + mScaleX,
          scaleY: 1.0 + oScaleY + mScaleY,
          child: LiquidItem(
            radius: widget.radius,
            color: widget.color,
            enableMotionBlur: false,
            onTap: _handleTap,
            child: widget.child,
          ),
        );
      },
    );
  }
}
