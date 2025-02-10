import 'dart:html';

class StorageService {
  static void savePubDevPackages(String json) {
    window.localStorage['pubDevPackages'] = json;
  }

  static String? get loadPubDevPackages {
    return window.localStorage['pubDevPackages'];
  }

  // Publisher packages
  static void savePublisherPackages(String json) {
    window.localStorage['publisherPackages'] = json;
  }

  static String? get loadPublisherPackages {
    return window.localStorage['publisherPackages'];
  }

  // Package details
  static void savePackageDetails(String packageUrl, String json) {
    final key = 'package_${Uri.encodeComponent(packageUrl)}';
    window.localStorage[key] = json;
  }

  static String? loadPackageDetails(String packageUrl) {
    final key = 'package_${Uri.encodeComponent(packageUrl)}';
    return window.localStorage[key];
  }

  // GitHub repositories
  static void saveGithubRepositories(String username, String json) {
    final key = 'github_repos_$username';
    window.localStorage[key] = json;
  }

  static String? loadGithubRepositories(String username) {
    final key = 'github_repos_$username';
    return window.localStorage[key];
  }

  // Cache cleanup method (optional)
  static void clearCache() {
    window.localStorage.clear();
  }
}
