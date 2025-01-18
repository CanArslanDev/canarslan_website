// ignore_for_file: unnecessary_overrides, public_member_api_docs

import 'package:canarslan_website/services/route_service.dart';
import 'package:get/get.dart';
import 'dart:html' as html;

//Base Controller For Getx
class BaseController extends GetxController {
  String currentHrefPath = html.window.location.pathname ?? '/';
  @override
  void onInit() {
    super.onInit();
    RouteService.controlMainHref(
        currentHrefPath, (path) => currentHrefPath = path);
  }

  @override
  void onClose() {
    super.onClose();
    // ignore: avoid_print
    // print("Starting base controller");
  }
}
