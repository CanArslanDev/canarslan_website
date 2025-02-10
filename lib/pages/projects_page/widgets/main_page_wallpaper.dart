part of '../projects_page.dart';

class _Wallpaper extends GetView<ProjectsPageController> {
  const _Wallpaper({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: controller.homePageTransition.value ? 1 : 0,
          child: Image.asset(
            'assets/images/main_wallpaper.png',
            width: 100.w,
            height: 100.h,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
