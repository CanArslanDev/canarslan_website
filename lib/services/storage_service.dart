import 'dart:html';

class StorageService {
  static void savePubDevPackages(String json) {
    window.localStorage['pubDevPackages'] = json;
  }

  static void saveRepositories(String json) {
    window.localStorage['repository'] = json;
  }

  static String? get loadPubDevPackages {
    return window.localStorage['pubDevPackages'];
  }

  static String? get loadRepositories {
    return window.localStorage['repository'];
  }
}
