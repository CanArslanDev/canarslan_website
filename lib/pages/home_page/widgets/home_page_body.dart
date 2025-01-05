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
              navBar,
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

  Widget get navBar => const _NavBar();

  Widget get intro => OrientationService.isPortrait
      ? const _IntroBodyPortrait()
      : const _IntroBodyLandscape();

  Widget get background => const _Background();
}
