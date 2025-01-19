import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:canarslan_website/services/feature_service.dart';
import 'package:get/get.dart';

mixin HomePageControllerIntroMixin {
  Future<void> Function(Duration duration) duration = FeatureService().duration;

  void setVsCodeLines(RxString line) {
    for (var i = 0; i < 20; i++) {
      line.value += '$i\n';
    }
  }

  Future<void> startAnimationWithNewLines(
    RxList<RxString> vsCodeText,
    RxBool forceQuitCursorAnimation,
  ) async {
    const text = '''
Hi, I am ${StringConstants.name}
Language: ${StringConstants.lang}
Framework: ${StringConstants.framework}
Age: ${StringConstants.age}''';
    var currentLine = ''.obs;
    vsCodeText.add(currentLine);
    for (var i = 0; i < text.length; i++) {
      if (text[i] == '\n') {
        currentLine = ''.obs;
        if (vsCodeText.length == 1) {
          await duration(const Duration(seconds: 1));
        }
        vsCodeText.add(currentLine);
      } else {
        currentLine.value += text[i];
        await duration(
          Duration(milliseconds: i < text.indexOf('\n') + 1 ? 85 : 60),
        );
      }
    }
    await duration(const Duration(milliseconds: 2000));
    forceQuitCursorAnimation.value = true;
  }

  Future<void> startAnimationCursorOpacity(
    RxBool cursorOpacity,
    RxBool forceQuitCursorAnimation,
  ) async {
    while (true) {
      await duration(const Duration(milliseconds: 300));
      if (forceQuitCursorAnimation.value) {
        cursorOpacity.value = false;
        break;
      }
      cursorOpacity.value = !cursorOpacity.value;
    }
  }

  Future<void> falseVisibility(RxBool visibility) async {
    await duration(const Duration(milliseconds: 7000));
    visibility.value = false;
  }

  Future<void> openTextFirstAnimation(RxBool visibility) async {
    await duration(const Duration(milliseconds: 8500));
    visibility.value = false;
  }

  Future<void> openTextSecondAnimation(Rx<int> count) async {
    await duration(const Duration(milliseconds: 9500));
    count.value = 1;

    await duration(const Duration(milliseconds: 150));
    count.value = 2;
  }

  Future<void> openMainWallpaperAnimation(RxBool wallpaperAnimation) async {
    await duration(const Duration(milliseconds: 6800));
    wallpaperAnimation.value = true;
  }

  Future<void> openInfoBarAnimation(Rx<bool> openInfoBar) async {
    await duration(const Duration(milliseconds: 7200));
    openInfoBar.value = true;
  }

  Future<void> closeInfoBarAnimation(Rx<bool> openInfoBar) async {
    openInfoBar.value = false;
  }

  Future<void> openContentAnimation(Rx<bool> contentAnimation) async {
    await duration(const Duration(milliseconds: 7500));
    contentAnimation.value = true;
  }

  Future<void> openDisposeAnimation(Rx<bool> disposeAnimation) async {
    await duration(const Duration(milliseconds: 8000));
    disposeAnimation.value = true;
  }

  Future<void> get openNavBarAnimation async {
    await duration(const Duration(milliseconds: 8000));
    Get.put<NavigationBarController>(NavigationBarController())
        .openNavbar
        .value = true;
  }

  Future<void> enableContentVisibleList(List<int> contentVisibleList) async {
    await duration(const Duration(milliseconds: 8000));
    for (var i = 1; i < contentVisibleList.length; i++) {
      contentVisibleList[i] = 1;
      await duration(const Duration(milliseconds: 400));
    }
  }

  void skipAnimation(HomePageController controller) {
    controller.visibility.value = false;
    controller.textAnimation.value = 2;
    controller.wallpaperAnimation.value = true;
    controller.openInfoBar.value = true;
    controller.openContent.value = true;
    controller.disposeAnimation.value = true;
    controller.contentVisibleList.value =
        List<int>.filled(controller.contentVisibleList.length, 1);
    Get.put<NavigationBarController>(NavigationBarController())
        .openNavbar
        .value = true;
  }
}
