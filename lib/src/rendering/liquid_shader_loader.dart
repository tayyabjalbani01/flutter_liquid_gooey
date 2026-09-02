import 'dart:ui' as ui;

/// Asynchronously loads and caches compiled GLSL [ui.FragmentProgram] instances.
class LiquidShaderLoader {
  static ui.FragmentProgram? _gooeyProgram;
  static ui.FragmentProgram? _meltProgram;

  static const String gooeyShaderAsset =
      'packages/flutter_liquid_gooey/shaders/liquid_gooey.frag';
  static const String meltShaderAsset =
      'packages/flutter_liquid_gooey/shaders/image_melt.frag';

  /// Preloads all fragment shader programs.
  static Future<void> preload() async {
    try {
      _gooeyProgram ??=
          await ui.FragmentProgram.fromAsset(gooeyShaderAsset);
    } catch (_) {
      // Fallback for standalone/example tests
      try {
        _gooeyProgram ??=
            await ui.FragmentProgram.fromAsset('shaders/liquid_gooey.frag');
      } catch (_) {}
    }

    try {
      _meltProgram ??=
          await ui.FragmentProgram.fromAsset(meltShaderAsset);
    } catch (_) {
      try {
        _meltProgram ??=
            await ui.FragmentProgram.fromAsset('shaders/image_melt.frag');
      } catch (_) {}
    }
  }

  static ui.FragmentProgram? get gooeyProgram => _gooeyProgram;
  static ui.FragmentProgram? get meltProgram => _meltProgram;
}
