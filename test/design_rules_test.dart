import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Machine-checked enforcement of the rules in `DESIGN.md`.
///
/// A written spec drifts the moment someone is in a hurry. These tests read
/// the source and fail the build when code steps outside the system, so the
/// rules hold without anyone having to remember them.
///
/// **Adding a page?** It is covered automatically. The only exempt files are
/// the ones still on the legacy allowlist below — that list is the migration
/// debt, and it should only ever shrink.
///
/// **Genuinely need an exception?** Put `// design-rules: allow <reason>` on
/// the offending line. It stays visible in review instead of silently
/// widening the rule.
void main() {
  /// Pre-redesign code, kept working until each page is rebuilt on SIGNAL.
  ///
  /// Now empty: every page runs on the design system, and the old tree is
  /// gone. Leave it that way — the list exists to be deleted from, not added
  /// to. New code is covered by every rule below with no opt-out.
  const legacy = <String>[];

  /// Files allowed to break a specific rule because they *define* it.
  const tokenFiles = <String>[
    'lib/design/tokens/signal_colors.dart',
    'lib/design/tokens/signal_spacing.dart',
    'lib/design/tokens/signal_typography.dart',
  ];

  /// One-off pages behind the passcode, which are not in this repository and
  /// are not the site. A scene drawn in its own palette has no business being
  /// held to the site's, and holding it there would only teach whoever wrote
  /// it that the escape hatch is routine.
  const outsideTheSystem = 'lib/private/';

  final files = Directory('lib')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where((f) => !f.path.startsWith(outsideTheSystem))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  bool isLegacy(String path) => legacy.any(path.startsWith);

  /// Every offending line, as `path:line: source`, skipping legacy files,
  /// escape-hatched lines and anything inside a `///` doc comment.
  List<String> scan(
    bool Function(String line) offends, {
    bool includeLegacy = false,
    List<String> exempt = const [],
  }) {
    final hits = <String>[];
    for (final file in files) {
      final path = file.path;
      if (!includeLegacy && isLegacy(path)) continue;
      if (exempt.any(path.endsWith)) continue;

      final lines = file.readAsLinesSync();

      // An escape hatch may sit on the offending line or in the comment block
      // directly above it, so a multi-line justification still counts.
      bool excused(int index) {
        if (lines[index].contains('design-rules: allow')) return true;
        for (var i = index - 1; i >= 0; i--) {
          final above = lines[i].trimLeft();
          if (!above.startsWith('//')) return false;
          if (above.contains('design-rules: allow')) return true;
        }
        return false;
      }

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i];
        if (line.trimLeft().startsWith('//')) continue;
        if (!offends(line)) continue;
        if (excused(i)) continue;
        hits.add('$path:${i + 1}: ${line.trim()}');
      }
    }
    return hits;
  }

  void expectClean(List<String> hits, String rule) {
    expect(
      hits,
      isEmpty,
      reason: '$rule\n${hits.join('\n')}',
    );
  }

  group('DESIGN.md — surfaces', () {
    test('radius is only ever 0 or a full pill', () {
      expectClean(
        scan(
          (l) => l.contains('Radius.circular('),
          exempt: tokenFiles,
        ),
        'Use SignalRadius.structural (0) or SignalRadius.interactive (pill). '
        'No other corner radius exists in the system — see DESIGN.md §Shape.',
      );
    });

    test('no shadows outside the two documented glows', () {
      expectClean(
        scan(
          (l) => l.contains('BoxShadow(') || l.contains('boxShadow:'),
          // The accent glow on a filled action and on an active tab are the
          // system's only elevation, and both live here.
          exempt: ['lib/design/components/signal_buttons.dart'],
        ),
        'Structure comes from 1px hairlines, not elevation — '
        'see DESIGN.md §Elevation.',
      );
    });

    test('no gradients', () {
      expectClean(
        scan((l) => l.contains('Gradient(')),
        'Fills are flat. A gradient is outside the system — '
        'see DESIGN.md §Elevation.',
      );
    });
  });

  group('DESIGN.md — colour', () {
    test('colours come from the palette, never from literals', () {
      expectClean(
        scan(
          (l) => RegExp(r'Color\(0x').hasMatch(l),
          exempt: tokenFiles,
        ),
        'Read colours from `context.signal` — see DESIGN.md §Palette.',
      );
    });

    test("Flutter's Colors table is not a palette", () {
      expectClean(
        scan(
          (l) => RegExp(r'\bColors\.').hasMatch(l),
          // ThemeData needs literal transparents to disable Material's
          // built-in splash and hover treatments.
          exempt: ['lib/design/theme/signal_theme.dart'],
        ),
        'Read colours from `context.signal` — see DESIGN.md §Palette.',
      );
    });
  });

  group('DESIGN.md — type', () {
    test('type comes from SignalType, never from a raw TextStyle', () {
      expectClean(
        scan(
          // Constructing a TextStyle, not merely naming one: `TextStyle(` also
          // appears inside `AnimatedDefaultTextStyle(`, which builds no style
          // of its own and is not what this rule is about.
          (l) => RegExp(r'(?<![A-Za-z])TextStyle\(').hasMatch(l),
          exempt: [
            ...tokenFiles,
            // Paints glyphs into the ASCII atlas, below the widget layer.
            'lib/design/components/signal_ascii_field.dart',
            // Composes the marquee face from display tokens inline.
            'lib/design/components/signal_marquee.dart',
          ],
        ),
        'Use a SignalType role — see DESIGN.md §Type.',
      );
    });

    test('fonts are bundled, not fetched at runtime', () {
      expectClean(
        scan((l) => l.contains('google_fonts')),
        'The three SIGNAL faces ship as assets — see DESIGN.md §Type.',
      );
    });
  });

  group('DESIGN.md — layout', () {
    test('sizing reads constraints, not viewport percentages', () {
      expectClean(
        scan((l) => l.contains('responsive_sizer')),
        'Use SignalBreakpoint and fluid() — see DESIGN.md §Layout.',
      );
    });
  });

  group('platform', () {
    test('no legacy web libraries anywhere', () {
      expectClean(
        scan(
          (l) =>
              l.contains('dart:html') ||
              l.contains("import 'dart:js'") ||
              l.contains('dart:js_util'),
          includeLegacy: true,
        ),
        'Use package:web with dart:js_interop. The legacy libraries are '
        'removed from Flutter and block a Wasm build.',
      );
    });
  });

  group('migration debt', () {
    test('the legacy allowlist still describes real paths', () {
      for (final entry in legacy) {
        final exists =
            Directory(entry).existsSync() || File(entry).existsSync();
        expect(
          exists,
          isTrue,
          reason: 'Legacy allowlist entry "$entry" no longer exists. '
              'Remove it — the list should only shrink.',
        );
      }
    });
  });
}
