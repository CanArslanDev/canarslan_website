import 'dart:async';
import 'dart:html' as html;

import 'package:canarslan_website/routes/pages.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RouteService {
  static bool get isMainHref =>
      (html.window.location.pathname ?? '/') == Routes.mainPage;
  static void setHref(String path) {
    var hrefPath = path;
    if (hrefPath.startsWith('/')) {
      hrefPath = hrefPath.substring(1);
    }
    html.window.history.pushState(null, 'Projects', '/$hrefPath');
  }

  static String get getHref => html.window.location.pathname ?? '/';

  static void controlMainHref(
    String currentHrefPath,
    void Function(String newPath) setHrefVoid,
  ) {
    void setMainHref(String newPath, {void Function()? timerEvent}) {
      final newRoute = newPath;
      setHrefVoid(newRoute);
      Timer(const Duration(milliseconds: 500), () {
        if (timerEvent != null) timerEvent();
        setHref(newRoute);
      });
    }

    if (currentHrefPath == '/') {
      setMainHref(Routes.homePage);
    } else if (!Pages.pages.any((element) => element.name == currentHrefPath) ||
        currentHrefPath == Routes.notFoundPage) {
      setMainHref(Routes.notFoundPage, timerEvent: () {
        Get.offAllNamed<dynamic>(Routes.notFoundPage);
      });
    }
  }

  static int get findCurrentNavigationPage {
    final currentPath = html.window.location.pathname;
    return hrefNavigationPageIndex(currentPath ?? '/');
  }

  static int hrefNavigationPageIndex(String path) {
    if (path == '/') return 0;
    final index = Pages.pages.indexWhere((element) => element.name == path);
    return index == -1 ? 0 : index;
  }
}
