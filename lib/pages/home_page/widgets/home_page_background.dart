part of '../home_page.dart';

class _Background extends GetView<HomePageController> {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return body;
  }

  Widget get body => Stack(
        children: [
          vsCodeWallpaper,
          mainWallpaper,
          blackHole,
        ],
      );

  Widget get vsCodeWallpaper => SizedBox(
        width: 100.w,
        height: 100.h,
        child: Image.asset('assets/images/wallpaper.png', fit: BoxFit.cover),
      );

  Widget get blackHole => Positioned(
        top: -Get.height * 4 * (Get.width / Get.height),
        left: -Get.width * 4,
        child: Obx(
          () => AnimatedContainer(
            margin: EdgeInsets.only(
              top: !controller.wallpaperAnimation.value
                  ? (Get.height * 4 * (Get.width / Get.height)) +
                      Get.height * 0.5
                  : (Get.height * 4 * (Get.width / Get.height)) / 2 +
                      Get.height * 0.5,
              left: !controller.wallpaperAnimation.value
                  ? Get.width * 4 + Get.width * 0.5
                  : Get.width * 2 + Get.width * 0.5,
            ),
            height: !controller.wallpaperAnimation.value
                ? 0
                : Get.height * 4 * (Get.width / Get.height),
            width: !controller.wallpaperAnimation.value ? 0 : Get.width * 4,
            curve: Curves.easeInOut,
            duration: const Duration(seconds: 2),
            child: Image.asset(
              'assets/images/black_hole.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      );

  Widget get mainWallpaper => const _GradientBackgroundAnimation();
}
