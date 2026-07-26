import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_locale.dart';
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
    // Above the router, so changing page keeps the language and changing
    // language does not disturb the route.
    return const SiteLocaleScope(child: _App());
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: StringConstants.name,
      debugShowCheckedModeBanner: false,
      theme: SignalTheme.instrument,
      getPages: Pages.pages,
      unknownRoute: Pages.unknown,
      initialRoute: RouteService.initialRoute,
      // Sections are siblings, and `RouteService.go` replaces rather than
      // pushes — so there is no stack for a slide to describe. The default
      // transition dragged the whole frame, nav bar and footer included,
      // sideways on every nav tap, which read as a mobile app pushing a
      // detail screen rather than as a site changing page. A page swap is
      // not an event worth animating; the section's own reveals are.
      defaultTransition: Transition.noTransition,
      transitionDuration: Duration.zero,
      // The site commits to the dark canvas; the paper palette appears as the
      // About band, not as a second theme.
      themeMode: ThemeMode.dark,
      darkTheme: SignalTheme.instrument,
    );
  }
}
