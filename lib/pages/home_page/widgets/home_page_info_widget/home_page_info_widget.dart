part of '../../home_page.dart';

class _InfoWidget extends GetView<HomePageController> {
  const _InfoWidget();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -25.w,
      top: (100.h / 2) - (70.h / 2),
      child: Obx(
        () => SizedBox(
          width: 46.w,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 2500),
            curve: Curves.fastLinearToSlowEaseIn,
            alignment: controller.openInfoBar.value
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: const _InfoWidgetBody(),
          ),
        ),
      ),
    );
  }
}
