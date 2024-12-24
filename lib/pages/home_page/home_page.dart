import 'dart:async';

import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:canarslan_website/extensions/string_extension.dart';
import 'package:canarslan_website/models/position_model.dart';
import 'package:canarslan_website/ui/app_padding.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:canarslan_website/ui/utils/text_styles.dart';
import 'package:canarslan_website/ui/widgets/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
part 'widgets/home_page_background.dart';
part 'widgets/home_page_body.dart';
part 'widgets/intro/home_page_intro_dock.dart';
part 'widgets/intro/home_page_intro_body.dart';
part 'widgets/intro/home_page_intro_vscode.dart';
part 'widgets/intro/home_page_intro_text.dart';
part 'widgets/intro/home_page_intro_positioned_text.dart';
part 'widgets/home_page_animated_gradient_background.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _Body(),
    );
  }
}
