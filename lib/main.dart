import 'package:canarslan_website/routes/pages.dart';
import 'package:canarslan_website/ui/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: AppThemes.mainTheme,
          getPages: Pages.pages,
          initialRoute: '/',
        );
      },
    );
  }
}
