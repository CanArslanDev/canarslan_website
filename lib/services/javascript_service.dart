// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

abstract class JavascriptService {
  static void openUrl(String url) =>
      js.context.callMethod('open', ['https://$url']);
}
