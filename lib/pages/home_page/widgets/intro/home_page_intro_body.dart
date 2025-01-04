part of '../../home_page.dart';

class _IntroBody extends GetView<HomePageController> {
  const _IntroBody();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: Stack(
        children: [
          mainBody,
          const _PositionedIntroText(),
          const _PositionedImText(),
        ],
      ),
    );
  }

  Widget get sizedBox => const SizedBox.shrink();

  Widget get mainBody => Obx(
        () => Stack(
          children: [
            vsCode,
            dock,
          ],
        ),
      );

  Widget get vsCode => SizedBox(
        width: 100.w,
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 1500),
            opacity: !controller.visibility.value ? 0 : 1,
            curve: Curves.fastLinearToSlowEaseIn,
            child: const _VsCode(),
          ),
        ),
      );

  Widget get dock => Positioned(
        bottom: -10.h,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding:
              EdgeInsets.only(bottom: controller.visibility.value ? 10.h : 0),
          width: 100.w,
          child: const _Dock(),
        ),
      );
}
