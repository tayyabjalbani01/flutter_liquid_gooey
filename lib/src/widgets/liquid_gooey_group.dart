import 'dart:ui' as ui;
import 'package:flutter/widgets.dart';
import 'package:flutter_liquid_gooey/src/models/blob_box.dart';
import 'package:flutter_liquid_gooey/src/rendering/liquid_shader_loader.dart';
import 'package:flutter_liquid_gooey/src/rendering/liquid_shader_painter.dart';
import 'package:flutter_liquid_gooey/src/rendering/liquid_vector_group_painter.dart';
import 'package:flutter_liquid_gooey/src/widgets/liquid_item_registration.dart';

/// Container group coordinating background liquid rendering behind crisp UI.
class LiquidGooeyGroup extends StatefulWidget {
  final Widget child;
  final Color fill;
  final double gooStrength;
  final double waviness;

  const LiquidGooeyGroup({
    super.key,
    required this.child,
    this.fill = const Color(0xFFFFFFFF),
    this.gooStrength = 28.0,
    this.waviness = 0.0,
  });

  @override
  State<LiquidGooeyGroup> createState() => _LiquidGooeyGroupState();
}

class _LiquidGooeyGroupState extends State<LiquidGooeyGroup> {
  final ValueNotifier<List<BlobBox>> _blobs = ValueNotifier<List<BlobBox>>([]);
  final Map<String, BlobBox> _registry = {};

  final GlobalKey _rootKey = GlobalKey();
  ui.FragmentShader? _shader;

  @override
  void initState() {
    super.initState();
    if (LiquidShaderLoader.gooeyProgram != null) {
      _shader = LiquidShaderLoader.gooeyProgram!.fragmentShader();
    }
    _initShader();
  }

  Future<void> _initShader() async {
    if (_shader != null) return;
    await LiquidShaderLoader.preload();
    if (mounted && LiquidShaderLoader.gooeyProgram != null) {
      setState(() {
        _shader = LiquidShaderLoader.gooeyProgram!.fragmentShader();
      });
    }
  }

  void _onUpdate(String id, BlobBox box) {
    _registry[id] = box;
    _blobs.value = _registry.values.toList();
  }

  void _onUnregister(String id) {
    _registry.remove(id);
    _blobs.value = _registry.values.toList();
  }

  @override
  void dispose() {
    _blobs.dispose();
    _shader?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CustomPainter backgroundPainter = _shader != null
        ? LiquidShaderPainter(
            shader: _shader!,
            blobs: _blobs,
            gooStrength: widget.gooStrength,
            waviness: widget.waviness,
            fillColor: widget.fill,
          )
        : LiquidVectorGroupPainter(
            blobs: _blobs,
            fillColor: widget.fill,
            gooStrength: widget.gooStrength,
          );

    return LiquidItemRegistration(
      onUpdate: _onUpdate,
      onUnregister: _onUnregister,
      fillColor: widget.fill,
      groupKey: _rootKey,
      child: Stack(
        key: _rootKey,
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(painter: backgroundPainter),
              ),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}
