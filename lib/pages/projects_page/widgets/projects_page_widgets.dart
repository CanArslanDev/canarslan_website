part of '../projects_page.dart';

class _Widgets extends GetView<ProjectsPageController> {
  const _Widgets();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      child: Column(
        children: [halfSizedBox, asciiText, mainButtons, asciiContainer],
      ),
    );
  }

  Widget get halfSizedBox => SizedBox(
        height: 40.h,
      );

  Widget get asciiText => const TitleAsciiArtText(
        finalAsciiText: constants.AsciiConstants.name,
        animationDuration: Duration(milliseconds: 2000),
      );

  Widget get mainButtons => _MainButtons();

  Widget get asciiContainer => Obx(() {
        if (controller.enableAsciiContainer.value) {
          if (OrientationService.isLandscape) {
            return const landscape.AsciiAnimationContainer();
          } else {
            return const portrait.AsciiAnimationContainer();
          }
        }
        return const SizedBox.shrink();
      });
}
