import 'package:canarslan_website/constants/package_constants.dart';
import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/extensions/string_extension.dart';
import 'package:canarslan_website/services/contributions_service.dart';
import 'package:canarslan_website/services/github_service.dart';
import 'package:canarslan_website/services/pub_dev_service.dart';
import 'package:flutter/foundation.dart';

/// Single source of the remote data the site shows.
///
/// Each request is fetched once per session and the future is kept, so
/// navigating between pages re-reads the same result instead of hitting the
/// network again. `HtmlService` layers its own `localStorage` cache underneath.
///
/// Both sources are read straight from public JSON APIs that allow
/// cross-origin requests, and both loaders swallow failure and return an empty
/// list. A page that cannot fetch shows nothing rather than an error state;
/// there is no version of this data worth interrupting a visitor over.
class SiteRepository {
  SiteRepository._();

  static final SiteRepository instance = SiteRepository._();

  Future<List<PackageInfo>>? _packages;
  Future<List<RepoInfo>>? _repositories;

  Future<ContributionYear>? _contributions;
  ContributionYear? _seededContributions;

  List<PackageInfo>? _seededPackages;
  List<RepoInfo>? _seededRepositories;

  Future<List<PackageInfo>> packages() {
    final seeded = _seededPackages;
    return _packages ??=
        seeded != null ? SynchronousFuture(seeded) : _loadPackages();
  }

  Future<ContributionYear> contributions() {
    final seeded = _seededContributions;
    return _contributions ??=
        seeded != null ? SynchronousFuture(seeded) : _loadContributions();
  }

  Future<List<RepoInfo>> repositories() {
    final seeded = _seededRepositories;
    return _repositories ??=
        seeded != null ? SynchronousFuture(seeded) : _loadRepositories();
  }

  Future<List<PackageInfo>> _loadPackages() async {
    final results = await Future.wait(
      PackageConstants.published.map(PubDevService.fetch),
    );
    return results.whereType<PackageInfo>().toList();
  }

  Future<ContributionYear> _loadContributions() =>
      ContributionsService.lastYear(
        StringConstants.github.getGithubNameFromUrl,
      );

  Future<List<RepoInfo>> _loadRepositories() => GitHubService.repositories(
        StringConstants.github.getGithubNameFromUrl,
      );

  /// Test seam — lets a widget test supply data without touching the network.
  ///
  /// Stores the values rather than a future: a `Future` created here would be
  /// born in `setUp`'s zone, outside the fake-async zone `testWidgets` runs
  /// in, and would never complete during the test. The future is built on
  /// first read instead, inside whatever zone is asking.
  void seed({
    List<PackageInfo>? packages,
    List<RepoInfo>? repositories,
    ContributionYear? contributions,
  }) {
    if (packages != null) {
      _seededPackages = packages;
      _packages = null;
    }
    if (repositories != null) {
      _seededRepositories = repositories;
      _repositories = null;
    }
    if (contributions != null) {
      _seededContributions = contributions;
      _contributions = null;
    }
  }
}
