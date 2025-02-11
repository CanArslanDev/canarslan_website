import 'dart:async';

import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ContactPageController extends BaseController {
  final welcomeText = '''
Last login: ${DateFormat('EEE MMM d HH:mm:ss').format(DateTime.now())}
Welcome User

////////////////////////////////////
/                                  /
/            Can Arslan            /
/         Mobile Developer         /
/                                  /
////////////////////////////////////

My mail address: canarslanx@gmail.com
You can use the links below to get information about me and to contact me.

''';
  final defaultText = ['This is my ', ' profile\n'];
  final urlNames = ['LinkedIn', 'GitHub', 'X'];
  Rx<String> welcomeTextAnimation = ''.obs;
  Rx<String> linkedInTextAnimation = ''.obs;
  Rx<String> githubTextAnimation = ''.obs;
  Rx<String> xTextAnimation = ''.obs;
  Rx<int> cursorTextAnimation = 0.obs;
  Rx<bool> cursorAnimation = false.obs;
  @override
  void onInit() {
    initialize;
    super.onInit();
  }

  Future<void> startWelcomeTextAnimation() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    for (var i = 0; i < welcomeText.length; i++) {
      welcomeTextAnimation.value += welcomeText[i];
      await Future<void>.delayed(const Duration(milliseconds: 5));
    }
  }

  Future<void> startUrlAnimations() async {
    for (var i = 0; i < 3; i++) {
      final text = '${defaultText[0]} ${urlNames[i]} ${defaultText[1]}';
      for (var j = 0; j < text.length; j++) {
        cursorTextAnimation.value = i + 1;
        if (i == 0) {
          linkedInTextAnimation.value += text[j];
        } else if (i == 1) {
          githubTextAnimation.value += text[j];
        } else {
          xTextAnimation.value += text[j];
        }

        await Future<void>.delayed(const Duration(milliseconds: 5));
      }
    }
  }

  Future<void> startCursorAnimation() async {
    var condition = true;
    while (condition) {
      cursorAnimation.value = !cursorAnimation.value;
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (xTextAnimation.value.length >
          defaultText[0].length + urlNames[2].length + defaultText[1].length) {
        Timer(const Duration(seconds: 2), () {
          condition = false;
          cursorAnimation.value = false;
        });
      }
    }
  }

  void get initialize {
    Get.put<NavigationBarController>(NavigationBarController())
        .openNavbar
        .value = true;
    startAnimations();
  }

  Future<void> startAnimations() async {
    unawaited(startCursorAnimation());
    await startWelcomeTextAnimation();
    await startUrlAnimations();
  }
}
