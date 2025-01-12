part of '../../home_page.dart';

class _ContentPackagesWidget extends GetView<HomePageController> {
  const _ContentPackagesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: packages,
      ),
    );
  }

  List<Widget> get packages {
    final widgets = <Widget>[];
    // widgets.add(package('Simple Animation Progress Bar',
    //     PackageConstants.packageIcons[0], 'pub.dev/packages/simple_painter'));
    // widgets.add(SizedBox(width: 3.w));
    // widgets.add(package('Simple Painter', PackageConstants.packageIcons[1],
    //     'pub.dev/packages/simple_animation_progress_bar'));
    // return widgets;
    for (var i = 0; i < controller.packages.entries.length; i++) {
      final entry = controller.packages.entries.elementAt(i);
      final key = entry.key;
      final value = entry.value;
      widgets.add(
          package(key.fixPackageName, PackageConstants.packageIcons[i], value));
      if (i != controller.packages.entries.length - 1) {
        widgets.add(SizedBox(width: 3.w));
      }
    }
    return widgets;
  }

  Widget package(
    String title,
    String iconPath,
    String url,
  ) =>
      Obx(
        () => AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          opacity: controller.contentVisibleList[5] == 1 ? 1 : 0,
          child: Column(
            children: [
              SvgPicture.asset(
                iconPath,
                height: OrientationService.contentPackagesImageSize,
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.5.h),
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => JavascriptService.openUrl(url),
                    child: SizedBox(
                      width: OrientationService.isPortrait ? 30.w : 9.5.w,
                      child: Text(title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            fontSize:
                                OrientationService.contentPackagesDescription,
                            color: AppColors.blue,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.blue,
                          )),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
