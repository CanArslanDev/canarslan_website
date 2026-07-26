part of '../home_page.dart';

/// The paper band, on the home page.
///
/// The site is dark end to end except here and on `/about`; turning the light
/// on mid-scroll is the strongest break the system has, so it happens once and
/// it marks the section that is about a person rather than about output.
///
/// Its field is [SignalFieldMode.ripple] — the other three are already spoken
/// for on this page, and rings expanding slowly suit the paper better than the
/// cockpit's turning arms.
class _AboutBand extends StatelessWidget {
  const _AboutBand();

  @override
  Widget build(BuildContext context) {
    return SignalInversion(
      child: SignalSection(
        field: SignalFieldMode.ripple,
        fieldOpacity: 0.55,
        ruled: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeading(
              eyebrow: 'Can Arslan // YAZILIM GELİŞTİRİCİ',
              stamp: 'About',
            ),
            const AboutBio(short: true),
            const SizedBox(height: SignalSpace.x12),
            SignalPillButton(
              label: 'More about me',
              trailing: '->',
              onPressed: () => RouteService.go(Routes.about),
            ),
          ],
        ),
      ),
    );
  }
}
