import 'package:canarslan_website/bindings/home_page_binding.dart';
import 'package:canarslan_website/bindings/main_page_binding.dart';
import 'package:canarslan_website/bindings/projects_page_binding.dart';
import 'package:canarslan_website/pages/home_page/home_page.dart';
import 'package:canarslan_website/pages/main_page/main_page.dart';
import 'package:canarslan_website/pages/projects_page/projects_page.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class Pages {
  static List<GetPage<Object>> pages = [
    GetPage(
        name: Routes.mainPage,
        page: () => const MainPage(),
        binding: MainPageBinding()),
    GetPage(
      name: Routes.homePage,
      page: () => const HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
        name: Routes.projectsPage,
        page: ProjectsPage.new,
        binding: ProjectsPageBinding())
  ];
}
