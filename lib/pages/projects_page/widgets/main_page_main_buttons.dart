part of '../projects_page.dart';

class _MainButtons extends GetView<ProjectsPageController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0.5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => AsciiArtButton(
              label: 'Projects',
              onPressed: () {
                controller.startAsciiAnimation.value = true;
                controller.switchButton.value = false;
              },
              height: 5,
              width: 0,
              direction: AnimationDirection.leftToRight,
              asciiAnimationTrigger: controller.startAsciiAnimation.value,
              completedAsciiAnimation: () {
                controller.enableAsciiContainer.value = true;
                controller.switchButton.value = false;
              },
            ),
          ),
          if (OrientationService.isPortrait) SizedBox(width: 2.w),
          Obx(
            () => AsciiArtButton(
              label: 'Packages',
              onPressed: () {
                controller.startAsciiAnimation.value = true;
                controller.switchButton.value = true;
                print(controller.switchButton.value);
              },
              height: 5,
              width: 0,
              direction: AnimationDirection.rightToLeft,
              asciiAnimationTrigger: controller.startAsciiAnimation.value,
              completedAsciiAnimation: () {},
            ),
          ),
        ],
      ),
    );
  }
}
