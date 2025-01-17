import 'dart:ui';

import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:get/get.dart';

class NavigationBarController extends BaseController {
  Rx<int> selectedPage = 0.obs;
  Rx<bool> openNavbar = false.obs;
  Rx<Size> menuItemSize = Size.zero.obs;
  void initialize() {
    Get.put<NavigationBarController>(NavigationBarController());
  }

  Future<void> changePage(int index) async {
    if (index != 0) {
      await Get.find<HomePageController>().closeWidgetsAnimation();
    }
    selectedPage.value = index;
  }
}
