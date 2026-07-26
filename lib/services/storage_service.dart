import 'package:canarslan_website/services/storage_service_stub.dart'
    if (dart.library.js_interop) 'package:canarslan_website/services/storage_service_web.dart';

/// Caches remote pub.dev and GitHub responses between visits, and remembers
/// the one preference the site has.
class StorageService {
  static const _publisherPackagesKey = 'publisherPackages';
  static const _localeKey = 'locale';

  // Language. Absent means the visitor has never chosen, which is not the same
  // as choosing English — it is what the default is for.
  static void saveLocale(String tag) => StorageBackend.write(_localeKey, tag);

  static String? get loadLocale => StorageBackend.read(_localeKey);

  // Publisher packages
  static void savePublisherPackages(String json) =>
      StorageBackend.write(_publisherPackagesKey, json);

  static String? get loadPublisherPackages =>
      StorageBackend.read(_publisherPackagesKey);

  // Package details
  static String _packageKey(String packageUrl) =>
      'package_${Uri.encodeComponent(packageUrl)}';

  static void savePackageDetails(String packageUrl, String json) =>
      StorageBackend.write(_packageKey(packageUrl), json);

  static String? loadPackageDetails(String packageUrl) =>
      StorageBackend.read(_packageKey(packageUrl));

  // GitHub repositories
  static String _reposKey(String username) => 'github_repos_$username';

  static void saveGithubRepositories(String username, String json) =>
      StorageBackend.write(_reposKey(username), json);

  static String? loadGithubRepositories(String username) =>
      StorageBackend.read(_reposKey(username));
}
