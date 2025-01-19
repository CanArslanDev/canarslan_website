import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:get/get.dart';

class HomePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(HomePageController.new, tag: 'HomePageController');
  }
}
