part of '../../../home_page.dart';

class _PositionedIntroTextLandscape extends GetView<HomePageController> {
  const _PositionedIntroTextLandscape();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.introNameTextPosition.value != Position.empty
          ? Positioned(
              top: controller.introNameTextPosition.value.y - 30.h,
              left: controller.introNameTextPosition.value.x,
              child: AnimatedOpacity(
                opacity: controller.contentVisibleList[0] == 1 ? 1 : 0,
                curve: Curves.easeInOut,
                duration: const Duration(milliseconds: 1000),
                child: Stack(
                  children: [
                    _coloredFitText,
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 2000),
                      curve: Curves.fastLinearToSlowEaseIn,
                      padding: EdgeInsets.only(
                        left: controller.visibility.value ? 0 : 2.w,
                      ),
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
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget get _coloredFitText => AnimatedContainer(
        duration: const Duration(milliseconds: 2000),
        curve: Curves.fastLinearToSlowEaseIn,
        padding: EdgeInsets.only(left: controller.visibility.value ? 0 : 2.w),
        width: 50.w,
        child: Align(
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 2000),
            curve: Curves.fastLinearToSlowEaseIn,
            width: _width,
            height: _height,
            child: AnimatedOpacity(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 2000),
              opacity: controller.textAnimation.value < 2 ? 0 : 1,
              child: FittedBox(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Text(
                      StringConstants.name,
                      style: AppTextStyles.title.copyWith(
                        fontSize: 11.sp,
                        color: AppColors.blue,
                        shadows: [
                          const BoxShadow(
                            color: AppColors.blue,
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget get _fitText => Obx(
        () => AnimatedOpacity(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 2000),
          opacity: controller.textAnimation.value < 2 ? 1 : 0,
          child: Opacity(
            opacity: controller.visibility.value ? 0 : 1,
            child: FittedBox(
              alignment: Alignment.bottomRight,
              child: Stack(
                children: [
                  Text(
                    StringConstants.name,
                    key: controller.mainTextWidgetKey,
                    style: AppTextStyles.title.copyWith(
                      fontSize: 11.sp,
                    ),
                  ),
                  const _AnimationTextLandscape(),
                ],
              ),
            ),
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
      return controller.nameTextSize.value!.height + 15.h;
    } else {
      return controller.nameTextSize.value!.height + 30.h;
    }
  }
}
