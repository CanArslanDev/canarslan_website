import 'dart:async';

import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:canarslan_website/controllers/projects_controller/ascii_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class ProjectsPageController extends BaseController {
  Rx<bool> startAsciiAnimation = false.obs;
  Rx<bool> enableAsciiContainer = false.obs;
  Rx<bool> homePageTransition = false.obs;
  AsciiController asciiController = AsciiController();
  Rx<bool> switchButton = false.obs;
  @override
  void onClose() {
    asciiController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    initialize;
    super.onInit();
  }

  void get initialize {
    Get.put<NavigationBarController>(NavigationBarController())
        .openNavbar
        .value = true;
  }

  void get startHomeTransitionAnimation {
    homePageTransition.value = true;
    Timer(const Duration(milliseconds: 500), () {
      homePageTransition.value = false;
    });
  }
}
