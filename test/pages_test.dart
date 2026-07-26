import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/data/site_repository.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/pages/about/about_page.dart';
import 'package:canarslan_website/pages/contact/contact_page.dart';
import 'package:canarslan_website/pages/home/home_page.dart';
import 'package:canarslan_website/pages/not_found/not_found_page.dart';
import 'package:canarslan_website/pages/packages/packages_page.dart';
import 'package:canarslan_website/pages/widgets/package_grid.dart';
import 'package:canarslan_website/pages/work/work_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Every page, at every width, with assertions on.
///
/// Release builds strip `assert`, so a page can look fine in a browser while
/// quietly overflowing. These tests are the only place that shows up.
void main() {
  const desktop = Size(1440, 1000);
  const tablet = Size(900, 1000);
  const phone = Size(390, 844);

  final pages = <String, Widget Function()>{
    'home': HomePage.new,
    'work': WorkPage.new,
    'packages': PackagesPage.new,
    'about': AboutPage.new,
    'contact': ContactPage.new,
    '404': NotFoundPage.new,
  };

  // Seven, matching the real publisher listing. The count matters: the home
  // preview trims to whole rows, and a seed with fewer packages than fit would
  // never exercise the trim.
  final seededPackages = [
    for (final (name, description) in const [
      ('flutter_liquid_glass', 'iOS 26 sıvı cam efektini Flutter’a taşıyan '
          'katman.'),
      ('offline_sync_kit', 'Çevrimdışı-önce veri senkronizasyonu.'),
      ('contributions_chart', 'GitHub katkı takvimini çizen widget.'),
      ('simple_painter', 'Tuval üstünde basit çizim araçları.'),
      ('simple_animation_progress_bar', 'Animasyonlu ilerleme çubuğu.'),
      ('flutter_blend_mask', 'Karışım modlarını widget ağacına taşır.'),
      ('rune', 'Küçük bir yardımcı araç seti.'),
    ])
      PackageInfo(
        name: name,
        url: 'https://pub.dev/packages/$name',
        description: description,
        publisher: 'canarslan.me',
        publishedAgo: '2 months ago',
        platforms: const ['Android', 'iOS', 'Web'],
        likes: '42',
        points: '160',
        downloads: '1.2k',
      ),
  ];

  setUp(() {
    // Pages must never reach the network in a test. Seeding also pins the
    // content, so a failure is about layout rather than about what GitHub
    // happened to return.
    SiteRepository.instance.seed(
      packages: seededPackages,
      repositories: const [
        RepoInfo(
          name: 'canarslan_website',
          description: 'Bu sitenin kendisi — Flutter web, açık kaynak.',
          language: 'Dart',
          languageColor: Color(0xFF00B4AB),
          stars: 27,
        ),
        RepoInfo(
          name: 'liquid_glass',
          description: '',
          language: 'Dart',
          languageColor: Color(0xFF00B4AB),
          stars: 42,
        ),
        RepoInfo(
          name: 'some_tool',
          description: 'Bir yardımcı araç.',
          language: 'Swift',
          languageColor: null,
          stars: 4,
        ),
      ],
    );
  });

  Future<void> pumpPage(
    WidgetTester tester,
    Widget page, {
    required Size size,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      FlutterError.dumpErrorToConsole(details, forceReport: true);
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    await tester.pumpWidget(
      MaterialApp(
        theme: SignalTheme.instrument,
        home: page,
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1200));
  }

  Future<void> teardownTree(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 50));
  }

  for (final entry in pages.entries) {
    group(entry.key, () {
      for (final (label, size) in [
        ('desktop', desktop),
        ('tablet', tablet),
        ('phone', phone),
      ]) {
        testWidgets('builds at $label without exceptions', (tester) async {
          await pumpPage(tester, entry.value(), size: size);
          final error = tester.takeException();
          expect(
            error,
            isNull,
            reason: '${entry.key} at ${size.width}px -> $error',
          );
          await teardownTree(tester);
        });
      }

      testWidgets('fits a phone screen', (tester) async {
        await pumpPage(tester, entry.value(), size: phone);

        // A box wider than the screen raises nothing — Wrap and Stack place it
        // happily and it runs off the edge. Geometry is the only signal.
        final tooWide = <String>[];
        void walk(RenderObject node) {
          final name = node.runtimeType.toString();
          // Content inside a clip or overflow box is deliberately larger than
          // its slot; the marquee track is the obvious one.
          if (name.contains('Clip') || name.contains('Overflow')) return;
          if (node is RenderBox &&
              node.hasSize &&
              node.size.width > phone.width + 0.5) {
            tooWide.add('$name ${node.size.width.toStringAsFixed(0)}px');
          }
          node.visitChildren(walk);
        }

        walk(tester.binding.renderViews.first);

        expect(
          tooWide.toSet().toList(),
          isEmpty,
          reason: '${entry.key} overflows a phone:\n${tooWide.toSet().join(
                '\n',
              )}',
        );
        await teardownTree(tester);
      });
    });
  }

  group('home page', () {
    for (final (label, size) in [
      ('desktop', desktop),
      ('tablet', tablet),
      ('phone', phone),
    ]) {
      testWidgets('the hero fills the first screen at $label', (tester) async {
        await pumpPage(tester, const HomePage(), size: size);

        // The hero is content-sized by nature, which on a tall window left a
        // strip of dead canvas under the marquee and made the page look like
        // it had stopped early. It now grows to fill whatever the window has
        // left, so the strip closes the first screen instead of floating above
        // the fold.
        //
        // Measured on the hero rather than on the marquee: the hero may
        // legitimately grow past the fold when the copy is tall — that is why
        // it takes a minimum height and not a fixed one — and then the marquee
        // is off-screen and never built.
        final available = size.height -
            SignalNavBar.height -
            SignalMarquee.heightFor(size.width);
        final hero = tester.getRect(find.byType(SignalAsciiField).first);

        expect(
          hero.height,
          greaterThanOrEqualTo(available - 1),
          reason: 'hero is ${hero.height} tall, needs at least $available '
              'to close the fold',
        );

        await teardownTree(tester);
      });
    }
  });

  group('packages', () {
    /// One per tile, and nothing else in the grid uses it.
    Finder tiles() => find.descendant(
          of: find.byType(PackageGrid),
          matching: find.byType(SignalScrambleText),
        );

    /// The home grid sits well below the fold, and a viewport does not lay out
    /// what it cannot reach — the tiles do not exist until it is scrolled to.
    Future<void> scrollToGrid(WidgetTester tester) async {
      await tester.dragUntilVisible(
        find.byType(PackageGrid),
        find.byType(Scrollable).first,
        const Offset(0, -400),
        maxIteration: 60,
      );
      await tester.pump(const Duration(milliseconds: 200));
    }

    testWidgets('the home preview fills whole rows', (tester) async {
      await pumpPage(tester, const HomePage(), size: desktop);
      await scrollToGrid(tester);

      // Three columns at this width, two rows deep. The preview used to take
      // a fixed four, which left one tile beside two empty cells and hid
      // three published packages for good.
      expect(tiles(), findsNWidgets(6));
      await teardownTree(tester);
    });

    testWidgets('the home preview drops a row on a tablet', (tester) async {
      await pumpPage(tester, const HomePage(), size: tablet);
      await scrollToGrid(tester);

      // Two columns here — the trim follows the grid rather than a constant.
      expect(tiles(), findsNWidgets(4));
      await teardownTree(tester);
    });

    testWidgets('the packages page shows every package', (tester) async {
      await pumpPage(tester, const PackagesPage(), size: desktop);

      expect(tiles(), findsNWidgets(seededPackages.length));
      await teardownTree(tester);
    });
  });

  group('work page', () {
    testWidgets('filtering narrows the list', (tester) async {
      await pumpPage(tester, const WorkPage(), size: desktop);

      expect(find.text('canarslan_website'), findsOneWidget);
      expect(find.text('some_tool'), findsOneWidget);

      await tester.tap(find.text('Swift'));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('some_tool'), findsOneWidget);
      expect(find.text('canarslan_website'), findsNothing);

      await teardownTree(tester);
    });
  });
}
