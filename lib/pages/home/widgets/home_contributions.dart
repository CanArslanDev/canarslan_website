part of '../home_page.dart';

/// A year of commits. The one chart on the site, and the reason the "live"
/// idea in the hero is not just a clock.
class _Contributions extends StatelessWidget {
  const _Contributions();

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final wide = !context.breakpoint.isCompact;

    return SignalSection(
      field: SignalFieldMode.scan,
      fieldOpacity: 0.28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'github.com/CanArslanDev',
            stamp: 'Last year',
            lede: 'Geçen bir yılın katkı takvimi — canlı olarak '
                "GitHub'dan çekiliyor.",
          ),
          SignalReveal(
            child: SignalCell(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // The widget draws a fixed grid, so it is given a concrete
                  // width rather than left to guess one.
                  final width = constraints.hasBoundedWidth
                      ? constraints.maxWidth
                      : 720.0;
                  return GitHubContributionsWidget(
                    githubUrl: 'https://${StringConstants.github}',
                    urlPrefix: 'https://api.codetabs.com/v1/proxy?quest=',
                    width: width,
                    backgroundColor: SignalPalette.transparent,
                    showCalendar: wide,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: SignalSpace.x6),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () =>
                  JavascriptService.openUrl(StringConstants.github),
              child: Text(
                'github.com/CanArslanDev ->'.toUpperCase(),
                style: SignalType.eyebrow(palette.accentText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
