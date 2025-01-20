import 'dart:html';

class StorageService {
  static void savePubDevPackages(String json) {
    window.localStorage['pubDevPackages'] = json;
  }

  static String? get loadPubDevPackages {
    return window.localStorage['pubDevPackages'];
  }
}
