import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class ContactPageController extends BaseController {
  final date = DateFormat('EEE MMM d HH:mm:ss').format(DateTime.now());
  @override
  void onInit() {
    initialize;
    super.onInit();
  }

  void get initialize {
    Get.put<NavigationBarController>(NavigationBarController())
        .openNavbar
        .value = true;
  }
}
