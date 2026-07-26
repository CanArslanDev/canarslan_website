import 'package:canarslan_website/services/javascript_service_stub.dart'
    if (dart.library.js_interop) 'package:canarslan_website/services/javascript_service_web.dart';

abstract class JavascriptService {
  /// Opens [url] in a new tab. URLs without a scheme are assumed to be https.
  static void openUrl(String url) => openUrlImpl(url);

  /// Mirrors the chosen language onto `<html lang>`.
  ///
  /// Flutter renders into a canvas, so nothing about the page's language is
  /// visible to anything outside it. The attribute is what a screen reader
  /// reads the pronunciation from and what a crawler indexes the language by,
  /// and it would otherwise stay whatever `index.html` shipped with.
  static void setDocumentLanguage(String tag) => setDocumentLanguageImpl(tag);
}
