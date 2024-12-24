part of '../../home_page.dart';

class _IntroBody extends GetView<HomePageController> {
  const _IntroBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        mainBody,
        const _PositionedIntroText(),
      ],
    );
  }

  Widget get sizedBox => const SizedBox.shrink();

  Widget get mainBody => Obx(
        () => AnimatedOpacity(
          duration: const Duration(milliseconds: 1500),
          opacity: !controller.visibility.value ? 0 : 1,
          curve: Curves.fastLinearToSlowEaseIn,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              sizedBox,
              const _VsCode(),
              const _Dock(),
            ],
          ),
        ),
      );
}
