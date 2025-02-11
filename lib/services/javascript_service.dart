// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

abstract class JavascriptService {
  static void openUrl(String url) {
    var newUrl = url;
    if (!url.startsWith('https://')) {
      newUrl = 'https://$url';
    }
    js.context.callMethod('open', [newUrl]);
  }
}
