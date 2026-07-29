import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/data/site_repository.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/i18n/site_locale.dart';
import 'package:canarslan_website/pages/about/about_page.dart';
import 'package:canarslan_website/pages/contact/contact_page.dart';
import 'package:canarslan_website/pages/home/home_page.dart';
import 'package:canarslan_website/pages/not_found/not_found_page.dart';
import 'package:canarslan_website/pages/packages/packages_page.dart';
import 'package:canarslan_website/pages/passcode/passcode_page.dart';
import 'package:canarslan_website/pages/projects/projects_page.dart';
import 'package:canarslan_website/pages/widgets/package_grid.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/storage_service.dart';
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
    'projects': ProjectsPage.new,
    'packages': PackagesPage.new,
    'about': AboutPage.new,
    'contact': ContactPage.new,
    'passcode': PasscodePage.new,
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
        published: DateTime.utc(2026, 5),
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
    SiteLocale locale = SiteLocale.en,
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

    // The scope reads its starting language from storage, so setting it here
    // exercises the restore path as well as the layout.
    StorageService.saveLocale(locale.tag);

    await tester.pumpWidget(
      MaterialApp(
        theme: SignalTheme.instrument,
        home: SiteLocaleScope(child: page),
        debugShowCheckedModeBanner: false,
      ),
    );
    await tester.pump(const Duration(milliseconds: 1200));
  }

  /// Every box laid out wider than the screen. A box that overflows raises
  /// nothing — `Wrap`, `Stack` and a clipped `Row` place it happily — so
  /// geometry is the only signal.
  List<String> spillage(WidgetTester tester, double width) {
    final tooWide = <String>[];
    void walk(RenderObject node) {
      final name = node.runtimeType.toString();
      // Content inside a clip or overflow box is deliberately larger than its
      // slot; the marquee track is the obvious one.
      if (name.contains('Clip') || name.contains('Overflow')) return;
      if (node is RenderBox && node.hasSize && node.size.width > width + 0.5) {
        tooWide.add('$name ${node.size.width.toStringAsFixed(0)}px');
      }
      node.visitChildren(walk);
    }

    walk(tester.binding.renderViews.first);
    return tooWide.toSet().toList();
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

      // Turkish is the longer language almost everywhere — the nav bar's
      // "Get in touch" becomes "İletişime geçin" — so a phone that fits in
      // English proves nothing about the site a Turkish visitor sees.
      for (final locale in SiteLocale.values) {
        testWidgets('fits a phone screen in ${locale.tag}', (tester) async {
          await pumpPage(tester, entry.value(), size: phone, locale: locale);

          expect(
            spillage(tester, phone.width),
            isEmpty,
            reason: '${entry.key} overflows a phone in ${locale.tag}',
          );
          await teardownTree(tester);
        });

        testWidgets('builds in ${locale.tag} on a phone', (tester) async {
          await pumpPage(tester, entry.value(), size: phone, locale: locale);
          expect(tester.takeException(), isNull);
          await teardownTree(tester);
        });
      }
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

  group('data rows', () {
    // The phone-overflow walk catches boxes that are too wide. This is the
    // mirror failure and just as silent: a row narrower than its column is
    // placed happily and simply sits in from the edge, and it only shows up
    // when one row in a list has more to say than the others.
    for (final (label, page) in [
      ('projects', ProjectsPage.new),
      ('contact', ContactPage.new),
    ]) {
      testWidgets('on $label all share one left edge', (tester) async {
        await pumpPage(tester, page(), size: phone);

        final rows = find.byType(SignalDataRow);
        expect(rows, findsWidgets);

        final boxes = [
          for (var i = 0; i < tester.widgetList(rows).length; i++)
            tester.getRect(rows.at(i)),
        ];
        expect(
          boxes.map((r) => r.left.round()).toSet(),
          hasLength(1),
          reason: 'rows start at different x: $boxes',
        );
        expect(
          boxes.map((r) => r.width.round()).toSet(),
          hasLength(1),
          reason: 'rows are different widths: $boxes',
        );

        await teardownTree(tester);
      });
    }
  });

  group('navigation', () {
    // Below `expanded` the bar drops the links, and for a while nothing took
    // their place: a phone or a tablet could reach exactly one of the five
    // routes. That the menu covers all of them is the point of it, so it is
    // asserted rather than assumed.
    for (final (label, size) in [('phone', phone), ('tablet', tablet)]) {
      testWidgets('every route is reachable on a $label', (tester) async {
        await pumpPage(tester, const HomePage(), size: size);

        expect(
          find.byType(SignalNavPanel),
          findsNothing,
          reason: 'the menu should start closed',
        );

        await tester.tap(find.text(CommonCopy.menu.en.toUpperCase()));
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.byType(SignalNavPanel), findsOneWidget);
        for (final (path, section) in Routes.navigation) {
          expect(
            find.text(section.en.toUpperCase()),
            findsWidgets,
            reason: '$path is missing from the menu',
          );
        }

        await teardownTree(tester);
      });
    }

    testWidgets('the bar sits everything on one line', (tester) async {
      await pumpPage(tester, const HomePage(), size: desktop);

      // The active link's underline costs 4px below the label, and with
      // nothing reserved above it the Row centred the label-plus-underline
      // and left the label itself riding 2px high — visible against the
      // language switch beside it, which is a bare line of the same type.
      final link = tester.getRect(find.text(SectionCopy.home.en.toUpperCase()));
      final switchLabel = tester.getRect(find.text(SiteLocale.en.label));
      final wordmark =
          tester.getRect(find.text(StringConstants.name.toUpperCase()));

      expect(
        link.center.dy,
        moreOrLessEquals(switchLabel.center.dy, epsilon: 0.5),
        reason: 'nav link and language switch are off by '
            '${(link.center.dy - switchLabel.center.dy).abs()}px',
      );
      expect(
        link.center.dy,
        moreOrLessEquals(wordmark.center.dy, epsilon: 0.5),
        reason: 'nav link and wordmark are off by '
            '${(link.center.dy - wordmark.center.dy).abs()}px',
      );

      await teardownTree(tester);
    });

    testWidgets('the bar keeps its links and its action on a desktop',
        (tester) async {
      await pumpPage(tester, const HomePage(), size: desktop);

      expect(find.text(CommonCopy.getInTouch.en.toUpperCase()), findsWidgets);
      expect(find.text(CommonCopy.menu.en.toUpperCase()), findsNothing);
      await teardownTree(tester);
    });

    testWidgets('widening past the breakpoint puts the page back',
        (tester) async {
      await pumpPage(tester, const HomePage(), size: phone);
      await tester.tap(find.text(CommonCopy.menu.en.toUpperCase()));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(SignalNavPanel), findsOneWidget);

      // The links are visible again at this width, so a panel standing in for
      // them has nothing left to stand in for.
      tester.view.physicalSize = desktop;
      await tester.pump();

      expect(find.byType(SignalNavPanel), findsNothing);

      // Then drain the reveal's delayed re-checks. The body is built fresh by
      // the frame above, so its 120/400/1000ms callbacks are scheduled from
      // that instant and would still be pending at teardown.
      await tester.pump(const Duration(milliseconds: 1200));
      await teardownTree(tester);
    });
  });

  group('language', () {
    testWidgets('the site opens in English', (tester) async {
      // No stored choice: the default is a decision, not the browser's guess.
      StorageService.saveLocale('');
      await tester.pumpWidget(
        const MaterialApp(
          home: SiteLocaleScope(child: AboutPage()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 1200));

      expect(find.text(AboutCopy.certificates.en.toUpperCase()), findsWidgets);
      expect(find.text(AboutCopy.certificates.tr.toUpperCase()), findsNothing);
      await teardownTree(tester);
    });

    testWidgets('the switch turns the whole page over', (tester) async {
      await pumpPage(tester, const AboutPage(), size: desktop);

      expect(find.text(SectionCopy.about.en.toUpperCase()), findsWidgets);

      await tester.tap(find.text(SiteLocale.tr.label));
      await tester.pump(const Duration(milliseconds: 400));

      // The stamp, an eyebrow and a plaque — three separate widgets that never
      // hear about each other, all following the one switch.
      expect(find.text(SectionCopy.about.tr.toUpperCase()), findsWidgets);
      expect(find.text(AboutCopy.certificates.tr.toUpperCase()), findsWidgets);
      expect(find.text(AboutCopy.certificate.tr.toUpperCase()), findsWidgets);
      expect(find.text(AboutCopy.certificates.en.toUpperCase()), findsNothing);

      await teardownTree(tester);
    });

    testWidgets('a stored choice survives a reload', (tester) async {
      await pumpPage(tester, const AboutPage(), size: desktop);
      await tester.tap(find.text(SiteLocale.tr.label));
      await tester.pump(const Duration(milliseconds: 200));
      await teardownTree(tester);

      // A fresh tree, as a reload would build — reading the same storage.
      await tester.pumpWidget(
        const MaterialApp(
          home: SiteLocaleScope(child: AboutPage()),
        ),
      );
      await tester.pump(const Duration(milliseconds: 1200));

      expect(find.text(AboutCopy.certificates.tr.toUpperCase()), findsWidgets);
      await teardownTree(tester);
    });
  });

  group('projects page', () {
    testWidgets('filtering narrows the list', (tester) async {
      await pumpPage(tester, const ProjectsPage(), size: desktop);

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
