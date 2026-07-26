import 'package:canarslan_website/services/storage_service_stub.dart'
    if (dart.library.js_interop) 'package:canarslan_website/services/storage_service_web.dart';

/// The two things the site keeps between visits: cached responses, and the
/// language the visitor chose.
///
/// Responses are stored under one namespaced key rather than a named method per
/// endpoint. The previous shape carried a save/load pair for the publisher
/// list, one for package details and one for repositories, of which only the
/// repository pair had a caller — the other four were left over from the
/// scraping implementation that this replaced.
class StorageService {
  static const _localeKey = 'locale';
  static const _responsePrefix = 'response_';

  // Language. Absent means the visitor has never chosen, which is not the same
  // as choosing English — it is what the default is for.
  static void saveLocale(String tag) => StorageBackend.write(_localeKey, tag);

  static String? get loadLocale => StorageBackend.read(_localeKey);

  // Cached responses. See ResponseCache for the envelope and the expiry.
  static void saveResponse(String key, String json) =>
      StorageBackend.write('$_responsePrefix${Uri.encodeComponent(key)}', json);

  static String? loadResponse(String key) =>
      StorageBackend.read('$_responsePrefix${Uri.encodeComponent(key)}');
}
