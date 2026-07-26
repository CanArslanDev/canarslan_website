part of '../home_page.dart';

/// Grows the hero to fill whatever the window has left, so the marquee lands
/// exactly on the fold rather than a little above it with dead space beneath.
///
/// The hero is content-sized by nature; on a tall window that left a strip of
/// empty canvas under the strip, which read as the page having stopped early.
/// A minimum — not a fixed height — so a short window or long copy still lets
/// the hero grow past the fold instead of clipping.
class _HeroViewport extends StatelessWidget {
  const _HeroViewport();

  @override
  Widget build(BuildContext context) {
    final window = MediaQuery.sizeOf(context);
    final available = window.height -
        SignalNavBar.height -
        SignalMarquee.heightFor(window.width);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: available > 0 ? available : 0),
      child: const _Hero(),
    );
  }
}

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
          SignalEyebrow(HomeCopy.heroEyebrow.of(context)),
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
                    text: HomeCopy.heroLede.of(context),
                    style: SignalType.lede(palette.fg)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: '\n${HomeCopy.heroSecondLine.of(context)}',
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
                label: HomeCopy.selectedWork.of(context),
                variant: SignalButtonVariant.filled,
                onPressed: () => RouteService.go(Routes.work),
              ),
              SignalPillButton(
                label: CommonCopy.getInTouch.of(context),
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
              label: HomeCopy.specPackages.of(context),
              // `--` rather than an em dash: it reads as an empty readout on a
              // mono strip, and the copy elsewhere has no em dashes either.
              value: count == null ? '--' : count.toString().padLeft(2, '0'),
            ),
            SignalSpecEntry(
              label: HomeCopy.specPublisherLabel.of(context),
              value: HomeCopy.specPublisherValue.of(context),
            ),
            SignalSpecEntry(
              label: HomeCopy.specOpenLabel.of(context),
              value: HomeCopy.specOpenValue.of(context),
            ),
            SignalSpecEntry(
              label: HomeCopy.specLive.of(context),
              child: SignalLiveClock(
                utcOffsetHours: IntConstants.timezone,
                label: HomeCopy.specLive.of(context),
              ),
            ),
          ],
        );
      },
    );
  }
}
