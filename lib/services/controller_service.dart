import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/contact_page_controller/contact_page_controller.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:canarslan_website/controllers/main_page_controller/main_page_controller.dart';
import 'package:canarslan_website/controllers/projects_controller/projects_page_controller.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ControllerService {
  static void putController(
    int controllerIndex,
    int currentIndex,
  ) {
    if (controllerIndex == currentIndex) return;
    //tag not working in this area
    switch (currentIndex) {
      case 0:
        Get.delete<HomePageController>();
      case 1:
        Get.delete<ProjectsPageController>();
      case 2:
        Get.delete<ContactPageController>();
    }

    switch (controllerIndex) {
      case 0:
        Get.put<HomePageController>(HomePageController());
      case 1:
        Get.put<ProjectsPageController>(ProjectsPageController());
        if (currentIndex == 0) {
          Get.find<ProjectsPageController>().startHomeTransitionAnimation;
        }
      case 2:
        Get.put<ContactPageController>(ContactPageController());
    }
  }

  static void putFirstPageController() {
    if (RouteService.isMainHref) {
      Get.put<HomePageController>(HomePageController());
    } else if (RouteService.getHref == Routes.projectsPage) {
      Get.put<ProjectsPageController>(ProjectsPageController());
    } else {
      Get.put<ContactPageController>(ContactPageController());
    }
  }
}
