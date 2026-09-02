import 'package:flutter/material.dart';
import 'package:flutter_liquid_gooey/flutter_liquid_gooey.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Liquid Component Widget Tests', () {
    testWidgets('LiquidItem mounts and renders child properly', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: LiquidItem(
            child: Text('Liquid Item Content'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Liquid Item Content'), findsOneWidget);
    });

    testWidgets('LiquidParent triggers tap callback on press', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: LiquidParent(
            onTap: () => tapped = true,
            child: const Text('Parent Trigger'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Parent Trigger'), findsOneWidget);
      await tester.tap(find.text('Parent Trigger'));
      await tester.pump(const Duration(milliseconds: 350));
      expect(tapped, isTrue);
    });

    testWidgets('LiquidChild renders with custom progress without error', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: LiquidChild(
            progress: 0.5,
            child: Text('Child Droplet'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Child Droplet'), findsOneWidget);
    });

    testWidgets('LiquidGooeyGroup renders children with vector fallback', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: LiquidGooeyGroup(
            child: Text('Gooey Group Child'),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Gooey Group Child'), findsOneWidget);
    });
  });
}
