part of '../home_page.dart';

class _Body extends GetView<HomePageController> {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background,
        intro,
        info,
        navBar,
        content,
      ],
    );
  }

  Widget get content => Obx(() => controller.openContent.value
      ? const _Content()
      : const SizedBox.shrink());

  Widget get info => const _InfoWidget();

  Widget get navBar => const _NavBar();

  Widget get intro => const _IntroBody();

  Widget get background => const SizedBox.expand(child: _Background());
}
