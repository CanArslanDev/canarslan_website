import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/routes/pages.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const CanArslanSite());
}

class CanArslanSite extends StatelessWidget {
  const CanArslanSite({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: StringConstants.name,
      debugShowCheckedModeBanner: false,
      theme: SignalTheme.instrument,
      getPages: Pages.pages,
      unknownRoute: Pages.unknown,
      initialRoute: RouteService.initialRoute,
      // The site commits to the dark canvas; the paper palette appears as the
      // About band, not as a second theme.
      themeMode: ThemeMode.dark,
      darkTheme: SignalTheme.instrument,
    );
  }
}
