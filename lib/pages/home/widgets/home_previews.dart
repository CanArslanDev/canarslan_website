part of '../home_page.dart';

/// The four most-starred repositories, as a taste of `/work`.
class _WorkPreview extends StatelessWidget {
  const _WorkPreview();

  static const _limit = 4;

  @override
  Widget build(BuildContext context) {
    return SignalSection(
      field: SignalFieldMode.wave,
      fieldOpacity: 0.42,
      fieldTintAccent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'Repositories',
            stamp: 'Selected work',
            lede: "GitHub'da en çok yıldız alan dört projem."
                '\nTamamına Work sayfasından ulaşabilirsiniz.',
            rule: true,
          ),
          FutureBuilder<List<RepoInfo>>(
            future: SiteRepository.instance.repositories(),
            builder: (context, snapshot) {
              final repos = snapshot.data;
              if (repos == null) {
                return const PagePlaceholder(message: 'Repolar yükleniyor');
              }
              if (repos.isEmpty) {
                return const PagePlaceholder(
                  message: 'Repolara şu anda ulaşılamıyor',
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepoList(repos: repos.take(_limit).toList()),
                  const SizedBox(height: SignalSpace.x8),
                  SignalPillButton(
                    label: 'All work',
                    trailing: '->',
                    onPressed: () => RouteService.go(Routes.work),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Two rows of packages, then a route to the rest.
///
/// Rows, not a count: the grid takes its column count from the width, so a
/// fixed limit of four left a dangling tile beside two empty cells on desktop
/// — three published packages simply never appeared.
class _PackagesPreview extends StatelessWidget {
  const _PackagesPreview();

  static const _rows = 2;

  @override
  Widget build(BuildContext context) {
    return SignalSection(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeading(
            eyebrow: 'pub.dev // canarslan.me',
            stamp: 'Packages',
            lede: "GitHub'da ve pub.dev'de paylaştığım açık kaynaklı "
                'paketlerim.'
                '\nTamamına Packages sayfasından ulaşabilirsiniz.',
          ),
          FutureBuilder<List<PackageInfo>>(
            future: SiteRepository.instance.packages(),
            builder: (context, snapshot) {
              final packages = snapshot.data;
              if (packages == null) {
                return const PagePlaceholder(message: 'Paketler yükleniyor');
              }
              if (packages.isEmpty) {
                return const PagePlaceholder(
                  message: 'Paketlere şu anda ulaşılamıyor',
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PackageGrid(packages: packages, maxRows: _rows),
                  const SizedBox(height: SignalSpace.x8),
                  SignalPillButton(
                    label: 'All packages',
                    trailing: '->',
                    onPressed: () => RouteService.go(Routes.packages),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
