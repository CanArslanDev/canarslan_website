part of '../home_page.dart';

/// The four most-starred repositories, as a taste of `/projects`.
class _ProjectsPreview extends StatelessWidget {
  const _ProjectsPreview();

  static const _limit = 4;

  @override
  Widget build(BuildContext context) {
    return SignalSection(
      field: SignalFieldMode.wave,
      fieldTintAccent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeading(
            eyebrow: HomeCopy.projectsEyebrow.of(context),
            stamp: HomeCopy.myProjects.of(context),
            lede: HomeCopy.projectsLede.of(context),
            rule: true,
          ),
          SiteData<List<RepoInfo>>(
            future: SiteRepository.instance.repositories(),
            loading: CommonCopy.loadingRepos,
            unavailable: CommonCopy.noRepos,
            builder: (context, repos) => _PreviewBlock(
              label: HomeCopy.allProjects.of(context),
              onPressed: () => RouteService.go(Routes.projects),
              child: RepoList(repos: repos.take(_limit).toList()),
            ),
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
            eyebrow: 'pub.dev // ${StringConstants.publisher}',
            stamp: SectionCopy.packages.of(context),
            lede: HomeCopy.packagesLede.of(context),
          ),
          SiteData<List<PackageInfo>>(
            future: SiteRepository.instance.packages(),
            loading: CommonCopy.loadingPackages,
            unavailable: CommonCopy.noPackages,
            builder: (context, packages) => _PreviewBlock(
              label: HomeCopy.allPackages.of(context),
              onPressed: () => RouteService.go(Routes.packages),
              child: PackageGrid(packages: packages, maxRows: _rows),
            ),
          ),
        ],
      ),
    );
  }
}

/// An excerpt with the route to the whole of it underneath.
///
/// Both previews on the home page are this shape: some of the list, a gap, and
/// a ghost button that goes to the page holding the rest.
class _PreviewBlock extends StatelessWidget {
  const _PreviewBlock({
    required this.label,
    required this.onPressed,
    required this.child,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        const SizedBox(height: SignalSpace.x8),
        SignalPillButton(label: label, trailing: '->', onPressed: onPressed),
      ],
    );
  }
}
