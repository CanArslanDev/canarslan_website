part of '../../home_page.dart';

class _PositionedIntroText extends GetView<HomePageController> {
  const _PositionedIntroText();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.widgetPosition.value != Position.empty
          ? Positioned(
              top: controller.widgetPosition.value.y - 30.h,
              left: controller.widgetPosition.value.x,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                padding: EdgeInsets.only(
                    left: controller.visibility.value ? 0 : 5.w),
                width: 50.w,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    width: _width,
                    height: _height,
                    child: _fitText,
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget get _fitText => FittedBox(
        alignment: Alignment.bottomRight,
        child: Text(
          'Can Arslan',
          style: AppTextStyles.title.copyWith(
            fontSize: 11.sp,
          ),
        ),
      );

  double? get _width {
    if (!controller.visibility.value) {
      return 17.w;
    } else {
      return controller.nameTextSize.value!.width;
    }
  }

  double? get _height {
    if (!controller.visibility.value) {
      return controller.nameTextSize.value!.height + 18.h;
    } else {
      return controller.nameTextSize.value!.height + 30.h;
    }
  }
}
