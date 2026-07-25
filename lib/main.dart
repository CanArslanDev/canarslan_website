import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:canarslan_website/routes/pages.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:canarslan_website/ui/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  NavigationBarController.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// The visitor-facing pages are all rendered inside [Routes.mainPage], which
  /// derives what to show from the URL itself. The design storybook is the one
  /// route that stands alone, so it is the only one resolved here.
  static String get _initialRoute =>
      RouteService.getHref == Routes.designPage
          ? Routes.designPage
          : Routes.mainPage;

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: StringConstants.name,
          debugShowCheckedModeBanner: false,
          theme: AppThemes.mainTheme,
          getPages: Pages.pages,
          initialRoute: _initialRoute,
        );
      },
    );
  }
}
