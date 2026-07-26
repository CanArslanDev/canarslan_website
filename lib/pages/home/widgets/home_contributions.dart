part of '../home_page.dart';

/// A year of commits. The one chart on the site, and the reason the "live"
/// idea in the hero is not just a clock.
class _Contributions extends StatelessWidget {
  const _Contributions();

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return SignalSection(
      field: SignalFieldMode.scan,
      fieldOpacity: 0.28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'github.com/CanArslanDev',
            stamp: 'Last year',
            lede: 'Son bir yılın katkı takvimi, canlı olarak '
                "GitHub'dan çekiliyor.",
          ),
          FutureBuilder<ContributionYear>(
            future: SiteRepository.instance.contributions(),
            builder: (context, snapshot) {
              final year = snapshot.data;
              if (year == null) {
                return const PagePlaceholder(message: 'Takvim yükleniyor');
              }
              if (year.isEmpty) {
                return const PagePlaceholder(
                  message: 'Katkı takvimine şu anda ulaşılamıyor',
                );
              }
              return SignalReveal(
                child: SignalCell(
                  child: ContributionCalendar(year: year),
                ),
              );
            },
          ),
          const SizedBox(height: SignalSpace.x6),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => JavascriptService.openUrl(StringConstants.github),
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
