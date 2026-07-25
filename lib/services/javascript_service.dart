import 'package:canarslan_website/services/javascript_service_stub.dart'
    if (dart.library.js_interop) 'package:canarslan_website/services/javascript_service_web.dart';

abstract class JavascriptService {
  /// Opens [url] in a new tab. URLs without a scheme are assumed to be https.
  static void openUrl(String url) => openUrlImpl(url);
}
