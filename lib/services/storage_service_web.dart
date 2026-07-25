import 'package:web/web.dart' as web;

/// Browser-backed key/value store.
class StorageBackend {
  static String? read(String key) => web.window.localStorage.getItem(key);

  static void write(String key, String value) =>
      web.window.localStorage.setItem(key, value);

  static void clear() => web.window.localStorage.clear();
}
