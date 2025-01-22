import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/main_page_controller/main_page_controller.dart';
import 'package:canarslan_website/services/feature_service.dart';
import 'package:get/get.dart';

class ProjectsPageController extends BaseController {
  Future<void> Function(Duration duration) duration = FeatureService().duration;
  Rx<bool> hideMainwallpaper = true.obs;

  @override
  void onInit() {
    super.onInit();

    if (!Get.isRegistered<MainPageController>()) {
      return;
    }
    openAnimation();
  }

  Future<void> openAnimation() async {
    hideMainwallpaper.value = false;
    await duration(const Duration(milliseconds: 100));

    hideMainwallpaper.value = true;
  }

  Future<void> closeAnimation() async {
    hideMainwallpaper.value = false;
    await duration(const Duration(seconds: 1));
  }
}
