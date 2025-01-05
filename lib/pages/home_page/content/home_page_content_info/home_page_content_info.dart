part of '../../home_page.dart';

class _ContentInfo extends GetView<HomePageController> {
  const _ContentInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: OrientationService.isPortrait ? 17.h : 25.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          texts,
          image,
        ],
      ),
    );
  }

  Widget get image => OrientationService.isPortrait
      ? const SizedBox.shrink()
      : Obx(() => AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            opacity: controller.contentVisibleList[0] == 1 ? 1 : 0,
            child: Image.asset(
              'assets/images/work_icon.png',
              height: OrientationService.contentImageHeight,
            ),
          ));

  Widget get texts => Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: controller.contentVisibleList[0] == 1 ? 1 : 0,
              child: SelectableText.rich(
                TextSpan(
                  style: AppTextStyles.codingBody.copyWith(
                    fontSize: OrientationService.contentTextSize,
                  ),
                  children: [
                    const TextSpan(
                      text: "I'm currently working on",
                    ),
                    TextSpan(
                      text: '\nFlutter & Dart Developing',
                      style: AppTextStyles.codingBody.copyWith(
                        fontSize: OrientationService.contentTextSize,
                        color: AppColors.blue,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          const BoxShadow(
                            color: AppColors.blue,
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: controller.contentVisibleList[1] == 1 ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.only(top: 0.5.h),
                child: SelectableText(
                  'I also share my projects on my\nGithub profile.',
                  maxLines: 2,
                  style: AppTextStyles.codingBody.copyWith(
                      fontSize: OrientationService.contentSmallTextSize),
                ),
              ),
            ),
            const _ContentInfoButtons(),
          ],
        ),
      );
}
