part of '../../home_page.dart';

class _ContentPackagesWidget extends GetView<HomePageController> {
  const _ContentPackagesWidget();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.6.h),
      child: Obx(
        () => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: controller.packages.isNotEmpty ? packages : nullWidget,
        ),
      ),
    );
  }

  List<Widget> get packages {
    final widgets = <Widget>[];
    for (var i = 0; i < controller.packages.length; i++) {
      final entry = controller.packages.elementAt(i);
      widgets.add(package(
          entry['name']!, PackageConstants.packageIcons[i], entry['url']!,),);
      if (i != controller.packages.length - 1) {
        widgets.add(SizedBox(width: 3.w));
      }
    }
    return widgets;
  }

  List<Widget> get nullWidget {
    return [
      Opacity(
        opacity: 0,
        child: package('Empty', PackageConstants.packageIcons[0], ''),
      ),
    ];
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
          opacity: controller.contentVisibleList[6] == true ? 1 : 0,
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
                          ),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
