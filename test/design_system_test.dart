import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/pages/design_page/design_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Assertion-level guard for the SIGNAL system.
///
/// Release builds strip `assert`, which hides exactly the failures this system
/// is prone to — `Container` given both a colour and a decoration, a `Row`
/// overflowing its constraints, a box asked for an infinite width. Widget
/// tests run with assertions on, so they catch that class of bug in CI instead
/// of in someone's browser console.
void main() {
  Future<void> pumpAt(
    WidgetTester tester,
    Widget child, {
    required Size size,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // The binding hides the first error inside `takeException`, which strips
    // the widget chain that makes an overflow actionable. Force every error to
    // print in full.
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details, forceReport: true);
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    await tester.pumpWidget(
      MaterialApp(
        theme: SignalTheme.instrument,
        home: child,
        debugShowCheckedModeBanner: false,
      ),
    );
    // Let entrance animations, reveal re-checks and the clock tick through.
    await tester.pump(const Duration(milliseconds: 1200));
    // Nudging the viewport forces a relayout, so a recurring error surfaces a
    // second time. The binding swallows the first one into `takeException`,
    // and only the later ones print the offending widget chain.
    tester.view.physicalSize = Size(size.width - 1, size.height);
    await tester.pump(const Duration(milliseconds: 16));
    final error = tester.takeException();
    expect(error, isNull, reason: 'at ${size.width}px wide -> $error');

    // Tear the tree down so periodic timers and tickers are disposed before
    // the test ends.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('SIGNAL storybook', () {
    testWidgets('builds at desktop width without exceptions', (tester) async {
      await pumpAt(tester, const DesignPage(), size: const Size(1440, 1000));
    });

    testWidgets('builds at tablet width without exceptions', (tester) async {
      await pumpAt(tester, const DesignPage(), size: const Size(900, 1000));
    });

    testWidgets('builds at phone width without exceptions', (tester) async {
      await pumpAt(tester, const DesignPage(), size: const Size(390, 844));
    });
  });

  group('SIGNAL storybook — portrait', () {
    testWidgets('nothing is laid out wider than a phone screen',
        (tester) async {
      const width = 390.0;
      tester.view
        ..physicalSize = const Size(width, 844)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: SignalTheme.instrument,
          home: const DesignPage(),
          debugShowCheckedModeBanner: false,
        ),
      );
      await tester.pump(const Duration(milliseconds: 1200));

      // A box wider than the screen does not raise an exception — `Wrap` and
      // `Stack` place it happily and it simply runs off the edge. That is how
      // three fixed-width panels shipped looking fine on desktop and broken on
      // a phone, so the check is on measured geometry, not on errors.
      final tooWide = <String>[];

      void walk(RenderObject node) {
        final name = node.runtimeType.toString();
        // Content inside a clip or an overflow box is deliberately larger than
        // its slot — the marquee track, for one.
        if (name.contains('Clip') || name.contains('Overflow')) return;
        if (node is RenderBox &&
            node.hasSize &&
            node.size.width > width + 0.5) {
          tooWide.add('$name is ${node.size.width.toStringAsFixed(0)}px wide');
        }
        node.visitChildren(walk);
      }

      walk(tester.binding.renderViews.first);

      expect(
        tooWide.toSet().toList(),
        isEmpty,
        reason: 'These overflow a ${width.toInt()}px screen:\n'
            '${tooWide.toSet().join('\n')}',
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 50));
    });
  });

  group('SIGNAL components', () {
    testWidgets('column fills its width rather than shrink-wrapping',
        (tester) async {
      tester.view
        ..physicalSize = const Size(1440, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      final key = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          theme: SignalTheme.instrument,
          home: Scaffold(
            body: SignalColumn(
              child: SizedBox(key: key, height: 10, width: double.infinity),
            ),
          ),
        ),
      );

      // 1280 column minus the 48px gutters on each side.
      final width = tester.getSize(find.byKey(key)).width;
      expect(
        width,
        SignalSpace.column - SignalSpace.x12 * 2,
        reason: 'column measured $width',
      );
    });

    testWidgets('marquee does not overflow its band', (tester) async {
      tester.view
        ..physicalSize = const Size(800, 400)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          theme: SignalTheme.instrument,
          home: const Scaffold(
            body: SignalMarquee(items: ['Flutter', 'Dart', 'Open source']),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  });
}
