part of '../home_page.dart';

class _DisposeAnimationTitle extends GetView<HomePageController> {
  const _DisposeAnimationTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.disposeAnimation.value ? title : const SizedBox.shrink(),
    );
  }

  Widget get title => Obx(
        () => AnimatedOpacity(
          duration: const Duration(milliseconds: 800),
          opacity: controller.contentVisibleList[0] == true ? 1 : 0,
          child: AppPadding(
              tPadding:
                  OrientationService.contentDisposeAnimationTextTopPadding,
              child: Align(
                alignment: Alignment.topCenter,
                child: SelectableText.rich(
                  TextSpan(
                    children: [
                      nameTag,
                      name,
                    ],
                  ),
                ),
              )),
        ),
      );

  TextSpan get nameTag => TextSpan(
        //previous text is 'I\'m ', i changed it to 'I'm ' to find easily
        text: '''I'm ''',
        style: AppTextStyles.title.copyWith(
          fontSize: OrientationService.contentDisposeAnimationTextFontSize,
          color: AppColors.white,
          shadows: [
            const BoxShadow(
              color: AppColors.white,
              blurRadius: 20,
            ),
          ],
        ),
      );

  TextSpan get name => TextSpan(
        text: StringConstants.name,
        style: AppTextStyles.title.copyWith(
          fontSize: OrientationService.contentDisposeAnimationTextFontSize,
          color: AppColors.blue,
          shadows: [
            const BoxShadow(
              color: AppColors.blue,
              blurRadius: 20,
            ),
          ],
        ),
      );
}
