import 'package:canarslan_website/controllers/projects_controller/projects_page_controller.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ProjectsPage extends GetView<ProjectsPageController> {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          mainWallpaper,
        ],
      ),
    );
  }

  Widget get mainWallpaper => Obx(
        () => AnimatedOpacity(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 1000),
          opacity: controller.hideMainwallpaper.value ? 0 : 1,
          child: SizedBox(
            width: Get.width,
            height: Get.height,
            child: Image.asset(
              'assets/images/main_wallpaper.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      );
}
