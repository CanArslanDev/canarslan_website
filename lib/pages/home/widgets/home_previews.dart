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
          PageHeading(
            eyebrow: HomeCopy.workEyebrow.of(context),
            stamp: HomeCopy.selectedWork.of(context),
            lede: HomeCopy.workLede.of(context),
            rule: true,
          ),
          FutureBuilder<List<RepoInfo>>(
            future: SiteRepository.instance.repositories(),
            builder: (context, snapshot) {
              final repos = snapshot.data;
              if (repos == null) {
                return PagePlaceholder(
                  message: CommonCopy.loadingRepos.of(context),
                );
              }
              if (repos.isEmpty) {
                return PagePlaceholder(
                  message: CommonCopy.noRepos.of(context),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RepoList(repos: repos.take(_limit).toList()),
                  const SizedBox(height: SignalSpace.x8),
                  SignalPillButton(
                    label: HomeCopy.allWork.of(context),
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
          PageHeading(
            eyebrow: 'pub.dev // canarslan.me',
            stamp: SectionCopy.packages.of(context),
            lede: HomeCopy.packagesLede.of(context),
          ),
          FutureBuilder<List<PackageInfo>>(
            future: SiteRepository.instance.packages(),
            builder: (context, snapshot) {
              final packages = snapshot.data;
              if (packages == null) {
                return PagePlaceholder(
                  message: CommonCopy.loadingPackages.of(context),
                );
              }
              if (packages.isEmpty) {
                return PagePlaceholder(
                  message: CommonCopy.noPackages.of(context),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PackageGrid(packages: packages, maxRows: _rows),
                  const SizedBox(height: SignalSpace.x8),
                  SignalPillButton(
                    label: HomeCopy.allPackages.of(context),
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
