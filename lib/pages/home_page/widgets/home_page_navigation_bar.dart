part of '../home_page.dart';

class _NavBar extends GetView<NavigationBarController> {
  const _NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = OrientationService.isPortrait ? 80.w : 37.w;
    return Positioned(
      left: 100.w / 2 - width / 2,
      top: -9.h,
      child: Obx(
        () => SizedBox(
          height: 15.7.h,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 2500),
            curve: Curves.fastLinearToSlowEaseIn,
            alignment: controller.openNavbar.value
                ? Alignment.bottomCenter
                : Alignment.topCenter,
            child: Container(
              height: 4.7.h,
              width: width,
              decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.4),
                  borderRadius: AppBorderRadius.medium,
                  border: Border.all(color: AppColors.grey, width: 2),
                  boxShadow: [
                    BoxShadow(
                      blurStyle: BlurStyle.outer,
                      color: AppColors.grey.withOpacity(0.5),
                      spreadRadius: -3,
                      blurRadius: 10,
                    ),
                  ]),
              child: Row(
                children: [
                  item('Home', 0),
                  item('Repositories', 1,
                      url: StringConstants.github.toGithubRepo),
                  item('Projects', 2,
                      url: StringConstants.github.toGithubProjects),
                  item('Packages', 3, url: StringConstants.pubDevPublisher),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget item(String title, int index, {String? url}) => Expanded(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (url != null) {
                JavascriptService.openUrl(url);
                return;
              }
              controller.selectedPage.value = index;
            },
            child: Obx(() => Container(
                  margin: EdgeInsets.all(5.5.sp),
                  decoration: BoxDecoration(
                    color: controller.selectedPage.value == index
                        ? AppColors.secondaryWhite.withOpacity(0.12)
                        : null,
                    borderRadius: AppBorderRadius.medium,
                  ),
                  child: Center(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.navBar,
                    ),
                  ),
                )),
          ),
        ),
      );
}
