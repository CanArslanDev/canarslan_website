import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/browser_location_stub.dart'
    if (dart.library.js_interop) 'package:canarslan_website/services/browser_location_web.dart';
import 'package:get/get.dart';

/// Navigation helpers.
///
/// Routing is GetX's own, which keeps the browser URL in sync. The previous
/// implementation pushed history entries by hand alongside it, which is why
/// deep links needed a `404.html` shim to work at all.
abstract class RouteService {
  /// The path the browser was opened at.
  static String get currentPath => currentBrowserPath();

  /// Where the app should start. Unknown paths land on the 404 page rather
  /// than silently redirecting, so a broken link stays visible.
  static String get initialRoute {
    final path = currentPath;
    return Routes.isKnown(path) ? path : Routes.notFound;
  }

  /// Navigate from the nav bar. Replaces rather than stacks: a site's
  /// top-level sections are siblings, so back should leave the site rather
  /// than walk a pile of visited tabs.
  static void go(String path) {
    if (Get.currentRoute == path) return;
    Get.offNamed<void>(path);
  }
}
