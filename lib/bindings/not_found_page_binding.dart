import 'package:canarslan_website/controllers/not_found_page_controller/not_found_page_controller.dart';
import 'package:get/get.dart';

class NotFoundPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(NotFoundPageController.new);
  }
}
