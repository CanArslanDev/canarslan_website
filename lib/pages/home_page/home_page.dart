import 'dart:async';

import 'package:canarslan_website/constants/int_constants.dart';
import 'package:canarslan_website/constants/package_constants.dart';
import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:canarslan_website/extensions/datetime_extension.dart';
import 'package:canarslan_website/extensions/string_extension.dart';
import 'package:canarslan_website/models/position_model.dart';
import 'package:canarslan_website/services/controller_service.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:canarslan_website/ui/border_radius.dart';
import 'package:canarslan_website/ui/icons.dart';
import 'package:canarslan_website/ui/padding.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:canarslan_website/ui/utils/text_styles.dart';
import 'package:canarslan_website/ui/widgets/measure_size.dart';
import 'package:contributions_chart/contributions_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

part 'content/home_page_content.dart';
part 'content/home_page_content_contributions/home_page_content_contributions.dart';
part 'content/home_page_content_info/home_page_content_info.dart';
part 'content/home_page_content_info/home_page_content_info_buttons.dart';
part 'content/home_page_content_info_widget/home_page_content_info_widget.dart';
part 'content/home_page_content_packages/home_page_content_packages.dart';
part 'content/home_page_content_packages/home_page_content_packages_title.dart';
part 'content/home_page_content_packages/home_page_content_packages_widget.dart';
part 'widgets/home_page_animated_gradient_background.dart';
part 'widgets/home_page_background.dart';
part 'widgets/home_page_body.dart';
part 'widgets/home_page_dispose_animation_title.dart';
part 'widgets/home_page_infinite_scroll_image.dart';
part 'widgets/home_page_info_widget/home_page_info_widget.dart';
part 'widgets/home_page_info_widget/home_page_info_widget_body.dart';
part 'widgets/intro/home_page_intro_dock.dart';
part 'widgets/intro/home_page_intro_positioned_im_text.dart';
part 'widgets/intro/landscape/home_page_intro_animation_text_landscape.dart';
part 'widgets/intro/landscape/home_page_intro_body_landscape.dart';
part 'widgets/intro/landscape/home_page_intro_positioned_text_landscape.dart';
part 'widgets/intro/landscape/home_page_intro_text_landscape.dart';
part 'widgets/intro/landscape/home_page_intro_vscode.dart';
part 'widgets/intro/portrait/home_page_intro_animation_text_portrait.dart';
part 'widgets/intro/portrait/home_page_intro_body_portrait.dart';
part 'widgets/intro/portrait/home_page_intro_notes.dart';
part 'widgets/intro/portrait/home_page_intro_positioned_text_portrait.dart';
part 'widgets/intro/portrait/home_page_intro_text_portrait.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ControllerService.putFirstPageController();
    return const Scaffold(
      body: _Body(),
    );
  }
}
