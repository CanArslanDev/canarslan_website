import 'dart:async';

import 'package:canarslan_website/routes/pages.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:get/get.dart';
import 'package:web/web.dart' as web;

class RouteService {
  static bool get isMainHref => getHref == Routes.mainPage;

  static void setHref(String path) {
    final hrefPath = path.startsWith('/') ? path.substring(1) : path;
    web.window.history.pushState(null, 'Projects', '/$hrefPath');
  }

  static String get getHref {
    final path = web.window.location.pathname;
    return path.isEmpty ? '/' : path;
  }

  static void controlMainHref(
    String currentHrefPath,
    void Function(String newPath) setHrefVoid,
  ) {
    void setMainHref(String newPath, {void Function()? timerEvent}) {
      setHrefVoid(newPath);
      Timer(const Duration(milliseconds: 500), () {
        timerEvent?.call();
        setHref(newPath);
      });
    }

    if (currentHrefPath == '/') {
      setMainHref(Routes.homePage);
    } else if (!Pages.pages.any((element) => element.name == currentHrefPath) ||
        currentHrefPath == Routes.notFoundPage) {
      setMainHref(
        Routes.notFoundPage,
        timerEvent: () => Get.offAllNamed<dynamic>(Routes.notFoundPage),
      );
    }
  }

  static int get findCurrentNavigationPage => hrefNavigationPageIndex(getHref);

  static int hrefNavigationPageIndex(String path) {
    if (path == '/') return 0;
    final index = Pages.pages.indexWhere((element) => element.name == path);
    return index == -1 ? 0 : index;
  }
}
