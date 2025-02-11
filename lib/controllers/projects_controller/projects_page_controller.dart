import 'dart:async';

import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/main_page_controller/main_page_controller.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:canarslan_website/controllers/projects_controller/ascii_controller.dart';
import 'package:canarslan_website/services/feature_service.dart';
import 'package:get/get.dart';

class ProjectsPageController extends BaseController {
  Rx<bool> startAsciiAnimation = false.obs;
  Rx<bool> enableAsciiContainer = false.obs;
  Rx<bool> homePageTransition = false.obs;
  AsciiController asciiController = AsciiController();
  Rx<bool> switchButton = false.obs;
  Future<void> Function(Duration duration) duration = FeatureService().duration;

  @override
  void onClose() {
    asciiController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    initialize;
    if (!Get.isRegistered<MainPageController>()) {
      return;
    }
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

  Future<void> closeAnimation() async {
    homePageTransition.value = true;
    await duration(const Duration(seconds: 1));
  }
}
