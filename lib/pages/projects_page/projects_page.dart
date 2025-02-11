import 'package:canarslan_website/constants/ascii_constants.dart' as constants;
import 'package:canarslan_website/controllers/projects_controller/projects_page_controller.dart';
import 'package:canarslan_website/services/controller_service.dart';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:canarslan_website/ui/ascii_animation_container_landscape/ascii_animation_container.dart'
    as landscape;
import 'package:canarslan_website/ui/ascii_animation_container_portrait/ascii_animation_container.dart'
    as portrait;
import 'package:canarslan_website/ui/ascii_art_button.dart';
import 'package:canarslan_website/ui/html_viewer.dart';
import 'package:canarslan_website/ui/title_ascii_art_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

part 'widgets/projects_page_main_buttons.dart';
part 'widgets/projects_page_wallpaper.dart';
part 'widgets/projects_page_widgets.dart';

class ProjectsPage extends GetView<ProjectsPageController> {
  const ProjectsPage({super.key});
  @override
  Widget build(BuildContext context) {
    ControllerService.putFirstPageController();
    return Scaffold(
      backgroundColor: const Color(0xFF071235),
      body: SingleChildScrollView(
        reverse: true,
        child: Stack(
          children: [
            htmlViewer,
            widgets,
            mainWallpaper,
          ],
        ),
      ),
    );
  }

  Widget get mainWallpaper => const _Wallpaper();

  Widget get htmlViewer => HtmlViewer(controller: controller.asciiController);

  Widget get widgets => const _Widgets();
}
