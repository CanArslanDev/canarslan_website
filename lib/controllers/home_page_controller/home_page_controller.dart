import 'dart:async';

import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller_intro.dart';
import 'package:canarslan_website/models/position_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomePageController extends BaseController
    with HomePageControllerIntroMixin {
  RxList<RxString> vsCodeText = <RxString>[].obs;
  RxBool visibility = true.obs;
  RxString vsCodeLines = ''.obs;
  RxBool cursorOpacity = true.obs;
  RxBool forceQuitCursorAnimation = false.obs;
  final GlobalKey textWidgetKey = GlobalKey();
  Rx<Position> widgetPosition = Position.empty.obs;
  RxBool textFirstAnimation = false.obs;
  Rx<Size?> nameTextSize = Size.zero.obs;
  RxBool wallpaperAnimation = false.obs;
  @override
  void onInit() {
    super.onInit();
    setVsCodeLines(vsCodeLines);
    startAnimationWithNewLines(vsCodeText, forceQuitCursorAnimation);
    startAnimationCursorOpacity(cursorOpacity, forceQuitCursorAnimation);
    findWidgetPosition();
    falseVisibility(visibility);
    openTextFirstAnimation(visibility);
    openMainWallpaperAnimation(wallpaperAnimation);
  }

  void findWidgetPosition() {
    Timer(const Duration(seconds: 5), () {
      final renderBox =
          textWidgetKey.currentContext!.findRenderObject()! as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      widgetPosition.value = Position(position.dx, position.dy);
    });
  }

  // ignore: use_setters_to_change_properties
  void setTextWidgetSize(Rx<Size> size) {
    nameTextSize = size;
  }
}
