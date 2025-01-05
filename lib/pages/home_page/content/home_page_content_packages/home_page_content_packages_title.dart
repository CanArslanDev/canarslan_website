part of '../../home_page.dart';

class _ContentPackagesTitle extends GetView<HomePageController> {
  const _ContentPackagesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        opacity: controller.contentVisibleList[4] == 1 ? 1 : 0,
        child: SelectableText.rich(
          TextSpan(
            style: AppTextStyles.body.copyWith(
                color: Colors.white,
                fontSize: OrientationService.contentPackagesTitle,
                fontWeight: FontWeight.w600),
            children: [
              const TextSpan(
                text: 'My',
              ),
              TextSpan(
                text: ' pub.dev',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: OrientationService.contentPackagesTitle,
                  shadows: [
                    const BoxShadow(
                      color: AppColors.blue,
                      blurRadius: 10,
                      spreadRadius: 1,
                    )
                  ],
                ),
              ),
              const TextSpan(
                text: ' packages',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
