import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/widgets/liquid_item.dart';

/// Pre-configured liquid child with flight motion blur and settling wobble.
class LiquidChild extends StatefulWidget {
  final Widget child;
  final double radius;
  final Color? color;
  final double progress;
  final double maxBlur;
  final VoidCallback? onTap;

  const LiquidChild({
    super.key,
    required this.child,
    this.radius = 24.0,
    this.color = const Color(0xFFFFFFFF),
    this.progress = 1.0,
    this.maxBlur = 3.5,
    this.onTap,
  });

  @override
  State<LiquidChild> createState() => _LiquidChildState();
}

class _LiquidChildState extends State<LiquidChild>
    with SingleTickerProviderStateMixin {
  late final AnimationController _settleWobble;

  @override
  void initState() {
    super.initState();
    _settleWobble = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
  }

  @override
  void didUpdateWidget(covariant LiquidChild oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress >= 0.99 && oldWidget.progress < 0.99) {
      _settleWobble.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _settleWobble.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _settleWobble,
      builder: (context, _) {
        final cw = _settleWobble.value;
        final childWobbleX = 1.0 + math.sin(cw * math.pi * 2.5) * 0.045 * (1.0 - cw);
        final childWobbleY = 1.0 - math.sin(cw * math.pi * 2.5) * 0.035 * (1.0 - cw);

        final blurSigma = (math.sin(widget.progress.clamp(0.0, 1.0) * math.pi) * widget.maxBlur);

        Widget content = widget.child;
        if (blurSigma > 0.3) {
          content = ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: content,
          );
        }

        return Transform.scale(
          scaleX: childWobbleX,
          scaleY: childWobbleY,
          child: LiquidItem(
            radius: widget.radius,
            color: widget.color,
            enableMotionBlur: false,
            onTap: widget.onTap,
            child: content,
          ),
        );
      },
    );
  }
}
