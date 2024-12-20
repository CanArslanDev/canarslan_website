import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller_intro.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomePageController extends BaseController
    with HomePageControllerIntroMixin {
  RxList<RxString> vsCodeText = <RxString>[].obs;
  RxString vsCodeLines = ''.obs;
  RxBool cursorOpacity = true.obs;

  @override
  void onInit() {
    super.onInit();
    setVsCodeLines(vsCodeLines);
    startAnimationWithNewLines(vsCodeText);
    startAnimationCursorOpacity(cursorOpacity);
  }
}
