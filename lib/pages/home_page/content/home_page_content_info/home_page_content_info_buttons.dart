part of '../../home_page.dart';

class _ContentInfoButtons extends GetView<HomePageController> {
  const _ContentInfoButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      tPadding: OrientationService.isPortrait ? 3.w : 1.w,
      child: Row(
        children: [
          button('Contact Me', StringConstants.linkedin, ButtonType.primary, 3),
          AppPadding(
            lPadding: OrientationService.isPortrait ? 3.w : 1.w,
            child: button('View My Projects',
                StringConstants.github.toGithubRepo, ButtonType.secondary, 4),
          ),
        ],
      ),
    );
  }

  Widget button(String text, String url, ButtonType type, int visibleIndex) =>
      Obx(
        () => AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          opacity: controller.contentVisibleList[visibleIndex] == true ? 1 : 0,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => JavascriptService.openUrl(url),
              child: Container(
                height: 3.8.h,
                padding: EdgeInsets.symmetric(
                    horizontal: OrientationService.isPortrait ? 2.w : 1.w),
                decoration: BoxDecoration(
                  color: type == ButtonType.primary
                      ? AppColors.lightBlue
                      : AppColors.white,
                  borderRadius: AppBorderRadius.extraSmall,
                  boxShadow: [
                    BoxShadow(
                      color: type == ButtonType.primary
                          ? AppColors.lightBlue
                          : AppColors.white.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 0.4,
                    )
                  ],
                ),
                child: Center(
                  child: Text(text,
                      style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: OrientationService.contentButtonTextSize,
                          color: type == ButtonType.primary
                              ? AppColors.white
                              : AppColors.black)),
                ),
              ),
            ),
          ),
        ),
      );
}

enum ButtonType { primary, secondary }
