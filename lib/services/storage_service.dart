import 'package:web/web.dart' as web;

/// Thin wrapper over `localStorage`, used to cache remote pub.dev and GitHub
/// data between visits.
class StorageService {
  static const _publisherPackagesKey = 'publisherPackages';

  static web.Storage get _store => web.window.localStorage;

  // Publisher packages
  static void savePublisherPackages(String json) =>
      _store.setItem(_publisherPackagesKey, json);

  static String? get loadPublisherPackages =>
      _store.getItem(_publisherPackagesKey);

  // Package details
  static String _packageKey(String packageUrl) =>
      'package_${Uri.encodeComponent(packageUrl)}';

  static void savePackageDetails(String packageUrl, String json) =>
      _store.setItem(_packageKey(packageUrl), json);

  static String? loadPackageDetails(String packageUrl) =>
      _store.getItem(_packageKey(packageUrl));

  // GitHub repositories
  static String _reposKey(String username) => 'github_repos_$username';

  static void saveGithubRepositories(String username, String json) =>
      _store.setItem(_reposKey(username), json);

  static String? loadGithubRepositories(String username) =>
      _store.getItem(_reposKey(username));

  static void clearCache() => _store.clear();
}
