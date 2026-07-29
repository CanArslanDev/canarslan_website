import 'package:canarslan_website/pages/about/about_page.dart';
import 'package:canarslan_website/pages/contact/contact_page.dart';
import 'package:canarslan_website/pages/design_page/design_page.dart';
import 'package:canarslan_website/pages/home/home_page.dart';
import 'package:canarslan_website/pages/not_found/not_found_page.dart';
import 'package:canarslan_website/pages/packages/packages_page.dart';
import 'package:canarslan_website/pages/passcode/passcode_page.dart';
import 'package:canarslan_website/pages/projects/projects_page.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:get/get.dart';

abstract class Pages {
  /// Every route is a page of its own. Nav items swap the route rather than
  /// scrolling one long document, so each section keeps its own URL, its own
  /// scroll position and its own data.
  static final List<GetPage<void>> pages = [
    GetPage(name: Routes.home, page: HomePage.new),
    GetPage(name: Routes.projects, page: ProjectsPage.new),
    GetPage(name: Routes.packages, page: PackagesPage.new),
    GetPage(name: Routes.about, page: AboutPage.new),
    GetPage(name: Routes.contact, page: ContactPage.new),
    GetPage(name: Routes.notFound, page: NotFoundPage.new),
    // Internal storybook, deliberately not in the navigation.
    GetPage(name: Routes.design, page: DesignPage.new),
    GetPage(name: Routes.passcode, page: PasscodePage.new),
  ];

  static final GetPage<void> unknown =
      GetPage(name: Routes.notFound, page: NotFoundPage.new);
}
