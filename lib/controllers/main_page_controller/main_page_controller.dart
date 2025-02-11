import 'dart:async';

import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:canarslan_website/extensions/string_extension.dart';
import 'package:canarslan_website/pages/contact_page/contact_page.dart';
import 'package:canarslan_website/pages/home_page/home_page.dart';
import 'package:canarslan_website/pages/projects_page/projects_page.dart';
import 'package:canarslan_website/services/html_service.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MainPageController extends BaseController {
  bool enableHomePageAnimation = RouteService.isMainHref;

  RxList<Map<String, String>> packages = <Map<String, String>>[].obs;
  RxList<Map<String, dynamic>> repositories = <Map<String, dynamic>>[].obs;
  List<Widget> pages = <Widget>[
    const HomePage(),
    const ProjectsPage(),
    const ContactPage(),
  ];
  final Rx<int> selectedIndex =
      Get.find<NavigationBarController>().selectedPage;

  @override
  void onInit() {
    super.onInit();
    getPackages();
    getRepositories();
  }

  Future<void> getPackages() async {
    packages.value =
        await HtmlService.fetchPackages(StringConstants.pubDevPublisher);
  }

  Future<void> getRepositories() async {
    repositories.value = await HtmlService()
        .fetchGitHubRepositories(StringConstants.github.getGithubNameFromUrl);
  }
}
