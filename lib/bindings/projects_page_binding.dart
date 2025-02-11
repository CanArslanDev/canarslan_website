import 'package:canarslan_website/controllers/projects_controller/projects_page_controller.dart';
import 'package:get/get.dart';

class ProjectsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ProjectsPageController.new, tag: 'ProjectsPageController');
  }
}
