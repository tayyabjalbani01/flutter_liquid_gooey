import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_liquid_gooey/flutter_liquid_gooey.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _spread;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 440),
    );
    _spread = CurvedAnimation(
      parent: _ctrl,
      curve: const Cubic(0.34, 1.40, 0.64, 1.0),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    _ctrl.isCompleted ? _ctrl.reverse() : _ctrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Liquid Gooey Group with Parent and Child Satellites
              AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) {
                  final t = _spread.value;
                  final goo = math.sin(_ctrl.value * math.pi) * 36.0;

                  return LiquidGooeyGroup(
                    fill: const Color(0xFFFFFFFF),
                    gooStrength: goo,
                    child: SizedBox(
                      width: 280.0,
                      height: 180.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 140.0 - 24.0 - t * 54.0,
                            top: 116.0 - 24.0 - t * 40.0,
                            child: LiquidChild(
                              progress: _ctrl.value,
                              onTap: () => _ctrl.reverse(),
                              child: const SizedBox(
                                width: 48.0,
                                height: 48.0,
                                child: Center(child: Text('📄')),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 140.0 - 24.0,
                            top: 116.0 - 24.0 - t * 62.0,
                            child: LiquidChild(
                              progress: _ctrl.value,
                              onTap: () => _ctrl.reverse(),
                              child: const SizedBox(
                                width: 48.0,
                                height: 48.0,
                                child: Center(child: Text('🖼️')),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 140.0 - 24.0 + t * 54.0,
                            top: 116.0 - 24.0 - t * 40.0,
                            child: LiquidChild(
                              progress: _ctrl.value,
                              onTap: () => _ctrl.reverse(),
                              child: const SizedBox(
                                width: 48.0,
                                height: 48.0,
                                child: Center(child: Text('📁')),
                              ),
                            ),
                          ),
                          LiquidParent(
                            isExpanded: _ctrl.value > 0.05,
                            onTap: _toggle,
                            child: SizedBox(
                              width: 56.0,
                              height: 56.0,
                              child: Center(
                                child: Transform.rotate(
                                  angle: t * (math.pi / 4.0),
                                  child: const Text(
                                    '+',
                                    style: TextStyle(
                                      color: Color(0xFF1C1C1E),
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32.0),
              // Standalone Interactive iOS Press & Wobble Button
              LiquidItem(
                radius: 26.0,
                color: const Color(0xFFFFFFFF),
                child: Container(
                  width: 200.0,
                  height: 52.0,
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app_rounded,
                        size: 18.0,
                        color: Color(0xFF1C1C1E),
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Tap for iOS Wobble',
                        style: TextStyle(
                          color: Color(0xFF1C1C1E),
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
