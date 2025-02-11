import 'package:canarslan_website/controllers/main_page_controller/main_page_controller.dart';
import 'package:canarslan_website/ui/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class MainPage extends GetView<MainPageController> {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Stack(
            children: [
              controller.pages.elementAt(controller.selectedIndex.value),
              navBar,
            ],
          ),),
    );
  }

  Widget get navBar => const NavBar();
}
