import 'package:canarslan_website/controllers/home_page_controller/home_page_controller.dart';
import 'package:canarslan_website/ui/app_padding.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:canarslan_website/ui/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
part 'widgets/home_page_background.dart';
part 'widgets/home_page_body.dart';
part 'widgets/intro/home_page_intro_dock.dart';
part 'widgets/intro/home_page_intro_body.dart';
part 'widgets/intro/home_page_intro_vscode.dart';
part 'widgets/intro/home_page_intro_text.dart';

class HomePage extends GetView<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _Body(),
    );
  }
}
