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
    // Two columns only where the plaques have room to sit two across. Below
    // that the certificates fall under the bio rather than being squeezed
    // beside it.
    final wide = context.breakpoint.isExpanded;

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
            if (wide)
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _Bio()),
                  SizedBox(width: SignalSpace.x12),
                  Expanded(flex: 6, child: _Certificates()),
                ],
              )
            else
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bio(),
                  SizedBox(height: SignalSpace.x16),
                  _Certificates(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _Bio extends StatelessWidget {
  const _Bio();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AboutBio(short: true),
        const SizedBox(height: SignalSpace.x8),
        SignalPillButton(
          label: 'More about me',
          trailing: '->',
          onPressed: () => RouteService.go(Routes.about),
        ),
      ],
    );
  }
}

class _Certificates extends StatelessWidget {
  const _Certificates();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SignalEyebrow('Certificates'),
        SizedBox(height: SignalSpace.x4),
        // Narrower than the About page's grid: in half a column the plaques
        // need to be allowed to sit two across rather than falling into one
        // tall stack.
        CredentialGrid(
          entries: AboutCredentials.certificates,
          plaque: 'Certificate',
          minTileWidth: 220,
        ),
      ],
    );
  }
}
