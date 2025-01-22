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
  late Rx<int> selectedPage;
  Rx<bool> openNavbar = false.obs;
  Rx<Size> menuItemSize = Size.zero.obs;

  @override
  void onInit() {
    super.onInit();
    selectedPage = initHrefPage.obs;
  }

  static void initialize() {
    Get.put<NavigationBarController>(NavigationBarController());
  }

  int get initHrefPage {
    final page = RouteService.findCurrentNavigationPage;

    ControllerService.putController(page, 0);
    if (page != 0) {
      openNavbar.value = true;
    }
    return page;
  }

  Future<void> changePage(int newIndex) async {
    final currentIndex = selectedPage.value;
    if (newIndex != 0) {
      Get.find<MainPageController>().enableHomePageAnmiation = false;
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
