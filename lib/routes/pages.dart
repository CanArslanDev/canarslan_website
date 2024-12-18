import 'package:canarslan_website/bindings/home_page_binding.dart';
import 'package:canarslan_website/pages/home_page/home_page.dart';
import 'package:canarslan_website/routes/routes.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

abstract class Pages {
  static List<GetPage<Object>> pages = [
    GetPage(
      name: Routes.homePage,
      page: () => const HomePage(),
      binding: HomePageBinding(),
    ),
  ];
}
