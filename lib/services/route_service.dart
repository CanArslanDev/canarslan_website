import 'dart:async';
import 'dart:html' as html;

import 'package:canarslan_website/routes/pages.dart';

class RouteService {
  static void setHref(String path) {
    var hrefPath = path;
    if (hrefPath.startsWith('/')) {
      hrefPath = hrefPath.substring(1);
    }
    print('set href: $hrefPath');
    html.window.history.pushState(null, 'Projects', '/$hrefPath');
  }

  static void controlMainHref(
      String currentHrefPath, void Function(String newPath) setHref) {
    if (currentHrefPath == '/') {
      setHref(Pages.pages[1].name);
      Timer(const Duration(milliseconds: 500), () {
        RouteService.setHref(currentHrefPath);
      });
    }
  }
}
