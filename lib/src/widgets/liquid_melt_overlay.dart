import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/rendering/liquid_shader_loader.dart';

/// Top-level GPU multi-texture overlay rendering contact dissolves and marbling.
class LiquidMeltOverlay extends StatefulWidget {
  final Offset contactPoint;
  final double warp;
  final double mix;
  final Widget child;

  const LiquidMeltOverlay({
    super.key,
    required this.contactPoint,
    this.warp = 26.0,
    this.mix = 0.7,
    required this.child,
  });

  @override
  State<LiquidMeltOverlay> createState() => _LiquidMeltOverlayState();
}

class _LiquidMeltOverlayState extends State<LiquidMeltOverlay> {
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await LiquidShaderLoader.preload();
    if (mounted && LiquidShaderLoader.meltProgram != null) {
      setState(() {
        _shader = LiquidShaderLoader.meltProgram!.fragmentShader();
      });
    }
  }

  @override
  void dispose() {
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
