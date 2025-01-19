import 'dart:ui';

import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/contact_page_controller/contact_page_controller.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:canarslan_website/controllers/main_page_controller/main_page_controller.dart';
import 'package:canarslan_website/controllers/projects_controller/projects_page_controller.dart';
import 'package:canarslan_website/routes/pages.dart';
import 'package:canarslan_website/services/controller_service.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:get/get.dart';

class NavigationBarController extends BaseController {
  Rx<int> selectedPage = 0.obs;
  Rx<bool> openNavbar = false.obs;
  Rx<Size> menuItemSize = Size.zero.obs;
  void initialize() {
    Get.put<NavigationBarController>(NavigationBarController());
  }

  Future<void> changePage(int newIndex) async {
    if (newIndex != 0) {
      Get.find<MainPageController>().enableHomePageAnimation = false;
      if (Get.isRegistered<HomePageController>()) {
        final homePageController = Get.find<HomePageController>();
        await homePageController.closeWidgetsAnimation();
      }
    }
    final currentIndex = selectedPage.value;
    selectedPage.value = newIndex;
    ControllerService.putController(newIndex, currentIndex);
  }
}
