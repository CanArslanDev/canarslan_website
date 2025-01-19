import 'package:canarslan_website/bindings/contact_page_binding.dart';
import 'package:canarslan_website/bindings/home_page_binding.dart';
import 'package:canarslan_website/bindings/main_page_binding.dart';
import 'package:canarslan_website/bindings/not_found_page_binding.dart';
import 'package:canarslan_website/bindings/projects_page_binding.dart';
import 'package:canarslan_website/pages/contact_page/contact_page.dart';
import 'package:canarslan_website/pages/home_page/home_page.dart';
import 'package:canarslan_website/pages/main_page/main_page.dart';
import 'package:canarslan_website/pages/not_found_page/not_found_page.dart';
import 'package:canarslan_website/pages/projects_page/projects_page.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class Pages {
  static List<GetPage<Object>> pages = [
    GetPage(
        name: Routes.mainPage, page: MainPage.new, binding: MainPageBinding()),
    GetPage(
      name: Routes.homePage,
      page: HomePage.new,
      binding: HomePageBinding(),
    ),
    GetPage(
        name: Routes.projectsPage,
        page: ProjectsPage.new,
        binding: ProjectsPageBinding()),
    GetPage(
        name: Routes.contactPage,
        page: ContactPage.new,
        binding: ContactPageBinding()),
    GetPage(
        name: Routes.notFoundPage,
        page: NotFoundPage.new,
        binding: NotFoundPageBinding()),
  ];
}
