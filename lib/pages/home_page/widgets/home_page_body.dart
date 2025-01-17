part of '../home_page.dart';

class _Body extends GetView<HomePageController> {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background,
        SingleChildScrollView(
          child: Stack(
            children: [
              intro,
              info,
              content,
            ],
          ),
        ),
      ],
    );
  }

  Widget get content => Obx(() => controller.openContent.value
      ? const _Content()
      : const SizedBox.shrink());

  Widget get info => OrientationService.isPortrait
      ? const SizedBox.shrink()
      : const _InfoWidget();

  Widget get intro => Obx(() => controller.disposeAnimation.value
      ? const SizedBox.shrink()
      : OrientationService.isPortrait
          ? const _IntroBodyPortrait()
          : const _IntroBodyLandscape());

  Widget get background => const _Background();
}
