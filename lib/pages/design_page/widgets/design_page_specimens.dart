part of '../design_page.dart';

/// Colour swatches, each a square hairline cell.
class _SwatchGrid extends StatelessWidget {
  const _SwatchGrid();

  /// Swatches read the live palette rather than repeating hex strings, so the
  /// storybook can never drift from the tokens it documents.
  static List<(Color, String, String)> _swatches(SignalPalette p) => [
        (
          p.canvas,
          'Canvas',
          'Sayfa zemini. Saf siyah değil — limon aksanla akraba olsun diye '
              'çok hafif yeşil eğimli.',
        ),
        (
          p.surface,
          'Surface',
          'Hücre zemini ve frosted nav. Zeminden yalnızca bir kademe ayrılır.',
        ),
        (
          p.recess,
          'Recess',
          'Input çukurları ve satır hover zemini.',
        ),
        (
          p.fg,
          'Foreground',
          'Birincil metin. Saf beyaz değil, kemik — siyah üzerinde parlamayı '
              'keser.',
        ),
        (
          p.muted,
          'Muted',
          'İkincil metin, eyebrow etiketleri, veri sütunları.',
        ),
        (
          p.accent,
          'Accent // Signal',
          'Tek kromatik ses. Dolgu, aktif durum ve ASCII alanların sıcak '
              'noktaları.',
        ),
        (
          p.inverse.canvas,
          'Paper',
          'Ters çevrilen müze bandının zemini. Tek bir bölümde kullanılır.',
        ),
        (
          p.lineHi,
          'Hairline',
          'Tüm yapıyı taşıyan çizgi. Gölge yok — ayrım iki opaklıktan gelir.',
        ),
      ];

  static String _hex(Color color) {
    final value = color.toARGB32() & 0xFFFFFF;
    return '#${value.toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return SignalTileGrid(
      minTileWidth: 216,
      maxColumns: 5,
      children: [
        for (final (color, name, role) in _swatches(palette))
          ColoredBox(
            color: palette.surface,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: color,
                    border: Border(bottom: BorderSide(color: palette.line)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(SignalSpace.x4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_hex(color), style: SignalType.caption(palette.fg)),
                      const SizedBox(height: SignalSpace.x1),
                      Text(
                        name,
                        style: SignalType.bodySmall(palette.fg)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: SignalSpace.x1),
                      Text(role, style: SignalType.bodySmall(palette.muted)),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TypeSection extends StatelessWidget {
  const _TypeSection();

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    Widget specimen(String label, Widget sample, String meta) => ColoredBox(
          color: palette.surface,
          child: Padding(
            padding: const EdgeInsets.all(SignalSpace.x6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SignalMicro(label),
                const SizedBox(height: SignalSpace.x3),
                ClipRect(child: sample),
                const SizedBox(height: SignalSpace.x3),
                Text(meta, style: SignalType.eyebrow(palette.muted)),
              ],
            ),
          ),
        );

    return SignalSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Head(
            eyebrow: 'The system // 02',
            stamp: 'Type',
            lede: 'Üç aile. Clash Display — düz kesilmiş uçlar, geometrik '
                'iskelet. General Sans gövde için. JetBrains Mono teknik ses. '
                'Display yalnızca iki uçta yaşar: 200 ve 700.',
            provenance: 'Kaynak: dope.security (General Sans) // gt-planar '
                '(mono) // leonardo.ai (display kütlesi)',
          ),
          SignalReveal(
            child: SignalTileGrid(
              minTileWidth: 420,
              maxColumns: 2,
              children: [
                specimen(
                  'Clash Display 700 — kütle',
                  const SignalDisplayLine(
                    'My projects',
                    weight: SignalDisplayWeight.mass,
                    section: true,
                  ),
                  'clamp(38–74px) // lh .90 // tracking −.035em',
                ),
                specimen(
                  'Clash Display 200 — hairline',
                  const SignalDisplayLine(
                    'My projects',
                    weight: SignalDisplayWeight.hair,
                    section: true,
                  ),
                  'clamp(38–74px) // lh .95 // tracking −.015em',
                ),
                specimen(
                  'JetBrains Mono 400 — bölüm damgası',
                  const SignalStamp('Packages', animate: false),
                  'uppercase // tracking +.2em // tek H2 aracı',
                ),
                specimen(
                  'General Sans 400/500 — gövde',
                  Text(
                    'Sitedeki tüm okunur metin burada. 15–18px, satır '
                    'yüksekliği 1.55, satır uzunluğu 56 karakteri geçmez.',
                    style: SignalType.body(palette.fg),
                  ),
                  '15 / 16 / 17 / 18px // lh 1.55',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bordered demo box used across the shape and component sections.
class _RuleBox extends StatelessWidget {
  const _RuleBox({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.signal.surface,
      child: Padding(
        padding: const EdgeInsets.all(SignalSpace.x6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SignalMicro(label),
            const SizedBox(height: SignalSpace.x4),
            child,
          ],
        ),
      ),
    );
  }
}

class _ShapeSwatch extends StatelessWidget {
  const _ShapeSwatch({required this.caption, required this.child});

  final String caption;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        const SizedBox(height: SignalSpace.x2),
        Text(
          caption.toUpperCase(),
          style: SignalType.eyebrow(context.signal.muted),
        ),
      ],
    );
  }
}

class _Ruler extends StatelessWidget {
  const _Ruler();

  @override
  Widget build(BuildContext context) {
    const steps = [4.0, 8.0, 12.0, 16.0, 24.0, 32.0, 40.0, 48.0, 56.0];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 56,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final step in steps) ...[
                Container(
                  width: 14,
                  height: step,
                  color: context.signal.lineHi,
                ),
                const SizedBox(width: 6),
              ],
            ],
          ),
        ),
        const SizedBox(height: SignalSpace.x3),
        Text(
          '4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 80 · 120',
          style: SignalType.eyebrow(context.signal.muted),
        ),
      ],
    );
  }
}

class _MotionRow extends StatelessWidget {
  const _MotionRow({
    required this.name,
    required this.where,
    required this.behaviour,
  });

  final String name;
  final String where;
  final String behaviour;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final wide = !context.breakpoint.isCompact;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SignalSpace.x4,
        vertical: SignalSpace.x3 + 2,
      ),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.line)),
      ),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 150,
                  child: Text(
                    name.toUpperCase(),
                    style: SignalType.caption(palette.fg),
                  ),
                ),
                SizedBox(
                  width: 170,
                  child: Text(
                    where,
                    style: SignalType.bodySmall(palette.muted),
                  ),
                ),
                Expanded(
                  child: Text(
                    behaviour,
                    style: SignalType.bodySmall(palette.muted),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toUpperCase(),
                  style: SignalType.caption(palette.fg),
                ),
                const SizedBox(height: SignalSpace.x1),
                Text(
                  '$where — $behaviour',
                  style: SignalType.bodySmall(palette.muted),
                ),
              ],
            ),
    );
  }
}

class _TabsDemo extends StatefulWidget {
  const _TabsDemo();

  @override
  State<_TabsDemo> createState() => _TabsDemoState();
}

class _TabsDemoState extends State<_TabsDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SignalTabs(
      labels: const ['All', 'Flutter', 'Dart', 'Package'],
      selected: _selected,
      onSelected: (index) => setState(() => _selected = index),
    );
  }
}

class _SwitchDemo extends StatefulWidget {
  const _SwitchDemo();

  @override
  State<_SwitchDemo> createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SignalLabelSwitch(
      labels: const ['EN', 'TR'],
      selected: _selected,
      onSelected: (index) => setState(() => _selected = index),
    );
  }
}

class _NavPanelDemo extends StatelessWidget {
  const _NavPanelDemo();

  @override
  Widget build(BuildContext context) {
    // A fixed height because this is a specimen, not layout: the panel fills
    // the body in use, and the tile grid measures its rows with an
    // IntrinsicHeight that the panel's own LayoutBuilder cannot answer.
    return SizedBox(
      height: 300,
      child: SignalNavPanel(
        selectedIndex: 1,
        items: [
          for (final (path, label) in Routes.navigation)
            SignalNavItem(
              label: label.of(context),
              meta: path,
              onTap: () => RouteService.go(path),
            ),
        ],
      ),
    );
  }
}

/// One museum plaque inside the paper band.
class _MuseumTile extends StatelessWidget {
  const _MuseumTile({
    required this.plaque,
    required this.title,
    required this.organisation,
  });

  final String plaque;
  final String title;
  final String organisation;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plaque.toUpperCase(),
          style: SignalType.micro(palette.muted)
              .copyWith(letterSpacing: 10 * 0.18),
        ),
        const SizedBox(height: SignalSpace.x2),
        Text(title, style: SignalType.cellTitle(palette.fg)),
        // A fixed gap under the Spacer: rows size to their tallest tile, so in
        // a short row the Spacer collapses to nothing and the organisation
        // would sit flush against the title.
        const SizedBox(height: SignalSpace.x6),
        const Spacer(),
        Text(organisation, style: SignalType.caption(palette.fg)),
      ],
    );
  }
}
