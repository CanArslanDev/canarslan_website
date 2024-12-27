import 'package:canarslan_website/constants/string_constants.dart';
import 'package:get/get.dart';

mixin HomePageControllerIntroMixin {
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
          await Future<void>.delayed(const Duration(seconds: 1));
        }
        vsCodeText.add(currentLine);
      } else {
        currentLine.value += text[i];
        await Future<void>.delayed(
          Duration(milliseconds: i < text.indexOf('\n') + 1 ? 85 : 60),
        );
      }
    }
    await Future<void>.delayed(const Duration(seconds: 1));
    forceQuitCursorAnimation.value = true;
  }

  Future<void> startAnimationCursorOpacity(
    RxBool cursorOpacity,
    RxBool forceQuitCursorAnimation,
  ) async {
    while (true) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (forceQuitCursorAnimation.value) {
        cursorOpacity.value = false;
        break;
      }
      cursorOpacity.value = !cursorOpacity.value;
    }
  }

  Future<void> falseVisibility(RxBool visibility) async {
    await Future<void>.delayed(const Duration(seconds: 6));
    visibility.value = false;
  }

  Future<void> openTextFirstAnimation(RxBool visibility) async {
    await Future<void>.delayed(const Duration(milliseconds: 7500));
    visibility.value = false;
  }

  Future<void> openTextSecondAnimation(Rx<int> count) async {
    await Future<void>.delayed(const Duration(milliseconds: 8500));
    count.value = 1;

    await Future<void>.delayed(const Duration(milliseconds: 150));
    count.value = 2;
  }

  Future<void> openMainWallpaperAnimation(RxBool wallpaperAnimation) async {
    await Future<void>.delayed(const Duration(milliseconds: 5800));
    wallpaperAnimation.value = true;
  }
}
