part of '../home_page.dart';

class _NavBar extends GetView<NavigationBarController> {
  const _NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 100.w / 2 - 37.w / 2,
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
              width: 37.w,
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
                  item('Repsitories', 1),
                  item('Projects', 2),
                  item('Packages', 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget item(String title, int index) => Expanded(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => controller.selectedPage(index),
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
                      style: AppTextStyles.navBar,
                    ),
                  ),
                )),
          ),
        ),
      );
}
