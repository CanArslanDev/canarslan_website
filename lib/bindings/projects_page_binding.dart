import 'package:canarslan_website/controllers/projects_controller/projects_page_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

class ProjectsPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ProjectsPageController.new, tag: 'ProjectsPageController');
  }
}
