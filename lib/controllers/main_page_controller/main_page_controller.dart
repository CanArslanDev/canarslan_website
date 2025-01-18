import 'dart:async';

import 'package:canarslan_website/controllers/base_controller.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:canarslan_website/pages/home_page/home_page.dart';
import 'package:canarslan_website/pages/main_page/main_page.dart';
import 'package:canarslan_website/pages/projects_page/projects_page.dart';
import 'package:canarslan_website/routes/pages.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'dart:html' as html;

class MainPageController extends BaseController {
  List<Widget> widgetOptions = <Widget>[const HomePage(), const ProjectsPage()];
  final Rx<int> selectedIndex =
      Get.find<NavigationBarController>().selectedPage;
}
