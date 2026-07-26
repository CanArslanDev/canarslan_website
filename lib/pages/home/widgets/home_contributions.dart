part of '../home_page.dart';

/// A year of commits. The one chart on the site, and the reason the "live"
/// idea in the hero is not just a clock.
class _Contributions extends StatelessWidget {
  const _Contributions();

  @override
  Widget build(BuildContext context) {
    return SignalSection(
      field: SignalFieldMode.scan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            eyebrow: StringConstants.github,
            stamp: HomeCopy.contributionsStamp.of(context),
            lede: HomeCopy.contributionsLede.of(context),
          ),
          SiteData<ContributionYear>(
            future: SiteRepository.instance.contributions(),
            loading: HomeCopy.loadingCalendar,
            unavailable: HomeCopy.noCalendar,
            isEmpty: (year) => year.isEmpty,
            builder: (context, year) => SignalReveal(
              child: SignalCell(child: ContributionCalendar(year: year)),
            ),
          ),
          const SizedBox(height: SignalSpace.x6),
          SignalTextLink(
            label: '${StringConstants.github} ->',
            onTap: () => JavascriptService.openUrl(StringConstants.github),
          ),
        ],
      ),
    );
  }
}
