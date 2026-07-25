part of '../home_page.dart';

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
              SignalPillButton(
                label: 'Selected work',
                variant: SignalButtonVariant.filled,
                onPressed: () => RouteService.go(Routes.work),
              ),
              SignalPillButton(
                label: 'Get in touch',
                trailing: '->',
                onPressed: () => RouteService.go(Routes.contact),
              ),
            ],
          ),
          const SizedBox(height: SignalSpace.x6),
          const _HeroSpec(),
        ],
      ),
    );
  }
}

/// The live readout. Package count comes from the real publisher listing, so
/// the strip is never stating something the packages page contradicts.
class _HeroSpec extends StatelessWidget {
  const _HeroSpec();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PackageInfo>>(
      future: SiteRepository.instance.packages(),
      builder: (context, snapshot) {
        final count = snapshot.data?.length;
        return SignalSpecStrip(
          entries: [
            SignalSpecEntry(
              label: 'Packages',
              value: count == null ? '—' : count.toString().padLeft(2, '0'),
            ),
            const SignalSpecEntry(label: 'pub.dev', value: 'Publisher'),
            const SignalSpecEntry(label: 'Open', value: 'Source'),
            SignalSpecEntry(
              label: 'Live',
              child: SignalLiveClock(utcOffsetHours: IntConstants.timezone),
            ),
          ],
        );
      },
    );
  }
}
