part of '../../../home_page.dart';

class _IntroBodyPortrait extends GetView<HomePageController> {
  const _IntroBodyPortrait();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Stack(
        children: [
          mainBody,
          const _PositionedIntroTextPortrait(),
          const _PositionedImText(),
        ],
      ),
    );
  }

  Widget get mainBody => Obx(
        () => SizedBox(
          width: 100.w,
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1500),
              opacity: !controller.visibility.value ? 0 : 1,
              curve: Curves.fastLinearToSlowEaseIn,
              child: const _Notes(),
            ),
          ),
        ),
      );
}
