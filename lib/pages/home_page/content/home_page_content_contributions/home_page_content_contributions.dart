part of '../../home_page.dart';

class _ContentContributions extends GetView<HomePageController> {
  const _ContentContributions();

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      tPadding: OrientationService.isPortrait ? 6.w : 2.w,
      child: Obx(
        () => Column(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: controller.contentVisibleList[7] == true ? 1 : 0,
              child: SelectableText(
                'My last year contributions',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: controller.contentVisibleList[8] == true ? 1 : 0,
              child: GitHubContributionsWidget(
                githubUrl: 'https://github.com/CanArslanDev',
                width: OrientationService.isPortrait ? 80.w : 30.w,
                urlPrefix: 'https://api.codetabs.com/v1/proxy?quest=',
                backgroundColor: Colors.transparent,
                showCalendar: true,
              ),
            ),
            if (OrientationService.isPortrait) SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
