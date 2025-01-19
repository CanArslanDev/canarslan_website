import 'package:canarslan_website/controllers/contact_page_controller/contact_page_controller.dart';
import 'package:get/get.dart';

class ContactPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(ContactPageController.new, tag: 'ContactPageController');
  }
}
