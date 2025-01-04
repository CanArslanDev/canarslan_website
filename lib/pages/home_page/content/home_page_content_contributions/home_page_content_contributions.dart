part of '../../home_page.dart';

class _ContentContributions extends GetView<HomePageController> {
  const _ContentContributions({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      tPadding: 2.w,
      child: Obx(
        () => Column(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: controller.contentVisibleList[6] == 1 ? 1 : 0,
              child: SelectableText(
                'My last year contributions',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 13.7.sp,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              opacity: controller.contentVisibleList[7] == 1 ? 1 : 0,
              child: Image.asset(
                'assets/images/contributions.png',
                fit: BoxFit.fitWidth,
                width: 36.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
