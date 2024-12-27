part of '../../home_page.dart';

class _PositionedImText extends GetView<HomePageController> {
  const _PositionedImText({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Positioned(
        top: controller.mainNameTextPosition.value.y,
        left: controller.mainNameTextPosition.value.x - removeWidth,
        child: AnimatedContainer(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 2000),
          padding: EdgeInsets.only(left: notEmpty ? 0 : removeWidth),
          child: AnimatedOpacity(
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 2000),
            opacity: notEmpty ? 1 : 0,
            child: SizedBox(
              height: height,
              child: MeasureSize(
                onChange: (value) {
                  controller.mainTextSize.value = value;
                },
                child: FittedBox(
                  child: Text(
                    '''I'm ''',
                    style: AppTextStyles.title.copyWith(
                        color: notEmpty ? Colors.white : Colors.transparent),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double get height {
    return 8.h;
  }

  bool get notEmpty {
    return controller.mainNameTextPosition.value != Position.empty;
  }

  double get removeWidth {
    if (controller.mainTextSize.value == null) {
      return 0;
    }
    return controller.mainTextSize.value!.width;
  }
}
