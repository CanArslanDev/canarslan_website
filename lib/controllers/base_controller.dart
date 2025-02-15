// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:canarslan_website/services/route_service.dart';
import 'package:get/get.dart';

//Base Controller For Getx
class BaseController extends GetxController {
  bool _disposed = false;

  String currentHrefPath = html.window.location.pathname ?? '/';
  @override
  void onInit() {
    super.onInit();
    RouteService.controlMainHref(
      currentHrefPath,
      (path) => currentHrefPath = path,
    );
  }

  @override
  void onClose() {
    super.onClose();
    _disposed = true;
  }

  bool get isDisposed => _disposed;

  void safelyDispose() {
    if (!_disposed) {
      dispose();
    }
  }
}
