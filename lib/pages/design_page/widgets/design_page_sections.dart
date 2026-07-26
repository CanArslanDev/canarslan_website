part of '../design_page.dart';

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return SignalSection(
      field: SignalFieldMode.vortex,
      fieldOpacity: 0.62,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Turkish words are authored uppercase: Dart's toUpperCase() is
          // locale-independent and would render "Türkiye" as "TÜRKIYE".
          const SignalEyebrow('Mobile engineer // Flutter & Dart // TÜRKİYE'),
          const SizedBox(height: SignalSpace.x6),
          const SignalDisplayLine('Can', weight: SignalDisplayWeight.mass),
          const SignalDisplayLine('Arslan', weight: SignalDisplayWeight.hair),
          const SizedBox(height: SignalSpace.x6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Yazılım geliştiriciyim ve ürünler geliştiriyorum.',
                    style: SignalType.lede(palette.fg)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: '\nYazdıklarımın çoğu açık kaynak — GitHub ve '
                        "pub.dev'de.",
                    style: SignalType.lede(palette.muted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SignalSpace.x6),
          Wrap(
            spacing: SignalSpace.x3,
            runSpacing: SignalSpace.x3,
            children: [
              const SignalPillButton(
                label: 'Selected work',
                variant: SignalButtonVariant.filled,
                onPressed: _noop,
              ),
              SignalPillButton(
                label: 'Get in touch',
                trailing: '->',
                onPressed: () => JavascriptService.openUrl(
                  'mailto:${StringConstants.email}',
                ),
              ),
            ],
          ),
          const SizedBox(height: SignalSpace.x6),
          const SignalSpecStrip(
            entries: [
              SignalSpecEntry(label: 'Packages', value: '05'),
              SignalSpecEntry(label: 'pub.dev', value: 'Publisher'),
              SignalSpecEntry(label: 'Open', value: 'Source'),
              SignalSpecEntry(
                label: 'Live',
                child: SignalLiveClock(utcOffsetHours: 3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaletteSection extends StatelessWidget {
  const _PaletteSection();

  @override
  Widget build(BuildContext context) {
    return const SignalSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Head(
            eyebrow: 'The system // 01',
            stamp: 'Palette',
            lede: 'Tek aksan. Kalan her şey akromatik. Aksan bir sayfada en '
                'fazla üç kez görünür: birincil aksiyon dolgusu, aktif durum, '
                'canlı veri işareti — dekorasyon olarak asla.',
            provenance:
                'Kaynak: eclipse (tek kromatik token) // dope.security '
                '(renk rasyonu)',
          ),
          SignalReveal(child: _SwatchGrid()),
        ],
      ),
    );
  }
}

class _ShapeSection extends StatelessWidget {
  const _ShapeSection();

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return SignalSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Head(
            eyebrow: 'The system // 03',
            stamp: 'Shape',
            lede: 'Sistemin en sert kuralı: köşe yarıçapı yalnızca iki değer '
                'alır. Yapısal olan keskin, etkileşimli olan tam pill. '
                'Aradaki her değer sistemin dışındadır.',
            provenance: 'Kaynak: gt-planar (iki kademeli radius) // mono '
                '(hücre gridi)',
          ),
          SignalReveal(
            child: SignalTileGrid(
              minTileWidth: 330,
              maxColumns: 3,
              children: [
                _RuleBox(
                  label: 'Radius',
                  child: Wrap(
                    spacing: SignalSpace.x6,
                    runSpacing: SignalSpace.x4,
                    children: [
                      _ShapeSwatch(
                        caption: '0px yapısal',
                        child: Container(
                          width: 64,
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(color: palette.lineHi),
                          ),
                        ),
                      ),
                      _ShapeSwatch(
                        caption: '999px etkileşimli',
                        child: Container(
                          width: 88,
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(color: palette.lineHi),
                            borderRadius: SignalRadius.interactive,
                          ),
                        ),
                      ),
                      _ShapeSwatch(
                        caption: '8/12/16px yasak',
                        child: Opacity(
                          opacity: 0.45,
                          child: Container(
                            width: 64,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(color: palette.line),
                              // design-rules: allow — this *is* the
                              // forbidden radius, drawn crossed out as
                              // the counterexample.
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'x',
                              style: SignalType.caption(palette.muted),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _RuleBox(
                  label: 'Elevation',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 300,
                        child: Text(
                          'Gölge yok. Yükseklik hissi 1px hairline’dan gelir. '
                          'Tek istisna: aktif pill’in aksan glow’u.',
                          style: SignalType.bodySmall(palette.muted),
                        ),
                      ),
                      const SizedBox(height: SignalSpace.x4),
                      const Wrap(
                        spacing: SignalSpace.x2,
                        children: [
                          SignalChip('idle'),
                          SignalChip('active', active: true),
                        ],
                      ),
                    ],
                  ),
                ),
                const _RuleBox(label: 'Spacing — 4px tabanı', child: _Ruler()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MotionSection extends StatelessWidget {
  const _MotionSection();

  @override
  Widget build(BuildContext context) {
    return SignalSection(
      field: SignalFieldMode.scan,
      fieldOpacity: 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Head(
            eyebrow: 'The system // 04',
            stamp: 'Motion',
            lede: 'Hareket sitenin her yerine dağılıyor ama tek bir kaynaktan '
                'besleniyor: ASCII karakter dokusu. Bu bölümün arkasında '
                'yatay tarama alanı çalışıyor.',
            provenance: 'Kaynak: mevcut sitenin ASCII motifi // gt-planar',
          ),
          SignalReveal(
            child: SignalCell(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  for (final (name, where, behaviour)
                      in const <(String, String, String)>[
                    (
                      'Vortex field',
                      'Hero arkası',
                      'Merkez etrafında dönen kutupsal girişim deseni',
                    ),
                    (
                      'Wave field',
                      'Selected work',
                      'Tamamen aksan renginde ilerleyen dalga',
                    ),
                    (
                      'Scan field',
                      'Motion & footer',
                      'Yukarı süzülen seyrek tarama satırları',
                    ),
                    (
                      'Scramble',
                      'Bölüm başlıkları',
                      'Karakterler rastgeleden hedefe oturur',
                    ),
                    (
                      'Glitch',
                      'Proje satırı hover',
                      'İsim 240ms karışır, sonra sabitlenir',
                    ),
                    (
                      'Drawline',
                      'Selected work',
                      'Aksan hairline soldan sağa çizilir',
                    ),
                    (
                      'Reveal',
                      'Bloklar',
                      '14px aşağıdan, 320ms, easeOutExpo',
                    ),
                  ])
                    _MotionRow(
                      name: name,
                      where: where,
                      behaviour: behaviour,
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ComponentsSection extends StatelessWidget {
  const _ComponentsSection();

  @override
  Widget build(BuildContext context) {
    return SignalSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Head(
            eyebrow: 'The system // 05',
            stamp: 'Components',
            lede: 'Her bileşen aynı üç kuraldan türüyor: hairline sınır, iki '
                'kademeli radius, tek aksan.',
          ),
          SignalReveal(
            child: SignalTileGrid(
              minTileWidth: 330,
              maxColumns: 2,
              children: [
                const _RuleBox(
                  label: 'Butonlar — filled + ghost, daima ikili',
                  child: Wrap(
                    spacing: SignalSpace.x3,
                    runSpacing: SignalSpace.x3,
                    children: [
                      SignalPillButton(
                        label: 'Primary',
                        variant: SignalButtonVariant.filled,
                        onPressed: _noop,
                      ),
                      SignalPillButton(
                        label: 'Secondary',
                        trailing: '->',
                        onPressed: _noop,
                      ),
                      SignalPillButton(
                        label: 'Small',
                        compact: true,
                        onPressed: _noop,
                      ),
                    ],
                  ),
                ),
                const _RuleBox(
                  label: 'Filtre sekmeleri — aktif pill glow’lu',
                  child: _TabsDemo(),
                ),
                const _RuleBox(
                  label: 'Etiket anahtarı — nav çubuğunun dil seçimi. '
                      'Aksan harcamaz: yanan taraf sadece foreground.',
                  child: _SwitchDemo(),
                ),
                const _RuleBox(
                  label: 'Etiketler',
                  child: Wrap(
                    spacing: SignalSpace.x2,
                    runSpacing: SignalSpace.x2,
                    children: [
                      SignalChip('Dart 3'),
                      SignalChip('Android'),
                      SignalChip('iOS'),
                      SignalChip('Web'),
                      SignalChip('Live', active: true),
                    ],
                  ),
                ),
                _RuleBox(
                  label: 'Eyebrow + damga ikilisi',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SignalEyebrow('Backed by data'),
                      const SizedBox(height: SignalSpace.x2),
                      Text(
                        'SSL INSPECTION',
                        style: SignalType.eyebrow(context.signal.fg).copyWith(
                          fontSize: 21,
                          letterSpacing: 21 * 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkSection extends StatelessWidget {
  const _WorkSection();

  static const _projects = <List<String>>[
    [
      'liquid_glass',
      'iOS 26 sıvı cam efektini Flutter’a taşıyan render katmanı.',
      'Dart',
      'pub.dev',
      '* 42',
    ],
    [
      'offline_sync_kit',
      'Çevrimdışı-önce veri senkronizasyonu; kuyruk ve çakışma çözümü.',
      'Dart',
      'pub.dev',
      '* 31',
    ],
    [
      'contributions_chart',
      'GitHub katkı takvimini herhangi bir kullanıcı için çizen widget.',
      'Dart',
      'pub.dev',
      '* 18',
    ],
    [
      'painter',
      'Canvas tabanlı çizim ve serbest el imza bileşeni.',
      'Dart',
      'pub.dev',
      '* 12',
    ],
    [
      'progress_bar',
      'Özelleştirilebilir, animasyonlu ilerleme göstergesi.',
      'Dart',
      'pub.dev',
      '* 9',
    ],
    [
      'canarslan_website',
      'Bu sitenin kendisi — Flutter web, açık kaynak.',
      'Dart',
      'GitHub',
      '* 27',
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return SignalSection(
      field: SignalFieldMode.wave,
      fieldOpacity: 0.42,
      fieldTintAccent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Head(
            eyebrow: 'Repositories & packages',
            stamp: 'Selected work',
            lede: 'Kart yok. Her proje, hover’da içeri kayan bir wireframe '
                'satır. Bu bölümün arkasındaki ASCII dalgası tamamen aksan '
                'renginde — rengin alanı ele geçirdiği tek yer.',
            rule: true,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: context.signal.line)),
            ),
            child: Column(
              children: [
                for (final project in _projects)
                  SignalDataRow(
                    name: project[0],
                    description: project[1],
                    meta: project.sublist(2),
                    onTap: () => JavascriptService.openUrl(
                      StringConstants.github,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: SignalSpace.x6),
          const SignalMicro(
            'Yıldız sayıları temsilîdir — canlı veri build sırasında çekilecek',
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection();

  static const _entries = <List<String>>[
    ['Certificate', 'Computer Science', 'Harvard University'],
    ['Certificate', 'Artificial Intelligence', 'Harvard University'],
    [
      'Certificate',
      'Computer Science for Business Professionals',
      'Harvard University',
    ],
    ['Certificate', 'Elements of AI', 'University of Helsinki'],
    ['Competition // Project Manager', 'Efficiency Challenge', 'Delta Cells'],
    ['Competition // Project Manager', 'Efficiency Challenge', 'Alaz'],
    [
      'Competition // Project Manager',
      'Technology for the Benefit of Humanity',
      'AKUS',
    ],
    ['Publisher', 'Five packages on pub.dev', 'canarslan.me'],
  ];

  @override
  Widget build(BuildContext context) {
    return SignalInversion(
      child: SignalSection(
        ruled: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Head(
              eyebrow: 'Inversion band // the museum',
              stamp: 'About',
              lede: 'Sayfada ışığın açıldığı tek yer. Sertifikalar ve '
                  'yarışmalar, 2px mürekkep çerçeveli hücrelerde müze etiketi '
                  'gibi duruyor.',
            ),
            SignalMuseumGrid(
              children: [
                for (final entry in _entries)
                  _MuseumTile(
                    plaque: entry[0],
                    title: entry[1],
                    organisation: entry[2],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
