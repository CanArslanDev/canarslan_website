import 'dart:ui';

import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/contact_page_controller/contact_page_controller.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:canarslan_website/controllers/main_page_controller/main_page_controller.dart';
import 'package:canarslan_website/controllers/projects_controller/projects_page_controller.dart';
import 'package:canarslan_website/routes/pages.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/controller_service.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:get/get.dart';

class NavigationBarController extends BaseController {
  Rx<int> selectedPage =
      (RouteService.getHref == Routes.homePage || RouteService.isMainHref)
          ? 0.obs
          : (RouteService.getHref == Routes.projectsPage)
              ? 1.obs
              : 2.obs;
  Rx<bool> openNavbar = false.obs;
  Rx<Size> menuItemSize = Size.zero.obs;

  @override
  void onInit() {
    super.onInit();
  }

  static void initialize() {
    Get.put<NavigationBarController>(NavigationBarController());
  }

  Future<void> changePage(int newIndex) async {
    final currentIndex = selectedPage.value;
    if (newIndex == 1) {
      Get.find<MainPageController>().enableHomePageAnimation = false;
      if (Get.isRegistered<HomePageController>()) {
        final homePageController = Get.find<HomePageController>();
        await homePageController.closeWidgetsAnimation();
      }
    } else if (currentIndex == 1 && newIndex == 0) {
      await Get.find<ProjectsPageController>().closeAnimation();
    }
    selectedPage.value = newIndex;
    ControllerService.putController(newIndex, currentIndex);
  }
}
