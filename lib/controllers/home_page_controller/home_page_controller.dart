import 'dart:async';

import 'package:canarslan_website/constants/int_constants.dart';
import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller_intro.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:canarslan_website/models/position_model.dart';
import 'package:canarslan_website/services/html_service.dart';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomePageController extends BaseController
    with HomePageControllerIntroMixin {
  RxList<RxString> vsCodeText = <RxString>[].obs;
  RxBool visibility = true.obs;
  RxString vsCodeLines = ''.obs;
  RxBool cursorOpacity = true.obs;
  RxBool forceQuitCursorAnimation = false.obs;
  final GlobalKey textWidgetKey = GlobalKey();
  final GlobalKey mainTextWidgetKey = GlobalKey();
  Rx<Position> introNameTextPosition = Position.empty.obs;
  Rx<Position> mainNameTextPosition = Position.empty.obs;
  RxBool textFirstAnimation = false.obs;
  Rx<Size?> nameTextSize = Size.zero.obs;
  Rx<Size?> mainTextSize = Size.zero.obs;
  RxBool wallpaperAnimation = false.obs;
  Rx<bool> openInfoBar = false.obs;
  Rx<bool> openContent = false.obs;
  Rx<bool> disposeAnimation = false.obs;
  Rx<int> textAnimation = 0.obs;
  DateTime time =
      DateTime.now().toUtc().add(Duration(hours: IntConstants.timezone));
  Map<String, String> packages = {};
  RxList<int> contentVisibleList = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0].obs;
  Rx<bool> loadedPortraitImages = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (OrientationService.isPortrait) {
      portrait;
    } else {
      landscape;
    }
  }

  void get portrait {
    getPackages();
    Timer(const Duration(seconds: 1), () {
      startAnimationWithNewLines(vsCodeText, forceQuitCursorAnimation);
      startAnimationCursorOpacity(cursorOpacity, forceQuitCursorAnimation);
      findIntroNameTextPosition();
      falseVisibility(visibility);
      openTextFirstAnimation(visibility);
      openTextSecondAnimation(textAnimation);
      openMainWallpaperAnimation(wallpaperAnimation);
      openInfoBarAnimation(openInfoBar);
      openContentAnimation(openContent);
      openDisposeAnimation(disposeAnimation);
      enableContentVisibleList(contentVisibleList);
      openNavBarAnimation;
      findMainNameTextPosition();
    });
  }

  void get landscape {
    getPackages();
    setVsCodeLines(vsCodeLines);
    startAnimationWithNewLines(vsCodeText, forceQuitCursorAnimation);
    startAnimationCursorOpacity(cursorOpacity, forceQuitCursorAnimation);
    findIntroNameTextPosition();
    falseVisibility(visibility);
    openTextFirstAnimation(visibility);
    openTextSecondAnimation(textAnimation);
    openMainWallpaperAnimation(wallpaperAnimation);
    openInfoBarAnimation(openInfoBar);
    openContentAnimation(openContent);
    enableContentVisibleList(contentVisibleList);
    openNavBarAnimation;
    findMainNameTextPosition();
  }

  Future<void> getPackages() async {
    packages =
        await HtmlService().fetchPackages(StringConstants.pubDevPublisher);
  }

  void findIntroNameTextPosition() {
    Timer(const Duration(milliseconds: 6000), () {
      if (textWidgetKey.currentContext == null) return;
      final renderBox =
          textWidgetKey.currentContext!.findRenderObject()! as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      introNameTextPosition.value = Position(position.dx, position.dy);
    });
  }

  void findMainNameTextPosition() {
    Timer(const Duration(milliseconds: 8000), () {
      if (mainTextWidgetKey.currentContext == null) return;
      final renderBox =
          mainTextWidgetKey.currentContext!.findRenderObject()! as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      mainNameTextPosition.value = Position(position.dx, position.dy);
    });
  }

  Future<void> closeWidgetsAnimation() async {
    unawaited(closeInfoBarAnimation(openInfoBar));
    for (var i = contentVisibleList.length - 1; i >= 0; i--) {
      contentVisibleList[i] = 0;
      await duration(const Duration(milliseconds: 50));
    }
    //wait animation ending
    await duration(const Duration(milliseconds: 1000));
  }
}
