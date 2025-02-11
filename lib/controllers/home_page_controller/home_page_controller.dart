import 'dart:async';

import 'package:canarslan_website/constants/int_constants.dart';
import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller_intro.dart';
import 'package:canarslan_website/controllers/main_page_controller/main_page_controller.dart';
import 'package:canarslan_website/models/position_model.dart';
import 'package:canarslan_website/services/html_service.dart';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  RxList<Map<String, String>> packages = <Map<String, String>>[].obs;
  RxList<bool> contentVisibleList =
      [true, false, false, false, false, false, false, false, false, false].obs;
  Rx<bool> loadedPortraitImages = false.obs;

  @override
  void onInit() {
    super.onInit();
    getPackages();
    if (!Get.isRegistered<MainPageController>() ||
        !Get.find<MainPageController>().enableHomePageAnimation) {
      skipAnimation(this);
      return;
    }
    if (OrientationService.isPortrait) {
      portrait;
    } else {
      landscape;
    }
  }

  void get portrait {
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
    packages.value =
        await HtmlService.fetchPackages(StringConstants.pubDevPublisher);
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
    if (!contentVisibleList.every((element) => element == true)) return;
    unawaited(closeInfoBarAnimation(openInfoBar));
    await closeContentVisibleList(contentVisibleList);
    //wait animation ending
    await duration(const Duration(milliseconds: 1000));
  }
}
