import 'package:canarslan_website/constants/string_constants.dart';
import 'package:get/get.dart';

mixin HomePageControllerIntroMixin {
  void setVsCodeLines(RxString line) {
    for (var i = 0; i < 20; i++) {
      line.value += '$i\n';
    }
  }

  Future<void> startAnimationWithNewLines(RxList<RxString> vsCodeText) async {
    const text = StringConstants.vsCode;
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
            Duration(milliseconds: i < text.indexOf('\n') + 1 ? 85 : 60));
      }
    }
  }

  Future<void> startAnimationCursorOpacity(RxBool cursorOpacity) async {
    while (true) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      cursorOpacity.value = !cursorOpacity.value;
    }
  }
}
