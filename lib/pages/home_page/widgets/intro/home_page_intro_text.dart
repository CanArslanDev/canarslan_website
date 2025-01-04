part of '../../home_page.dart';

class _IntroText extends GetView<HomePageController> {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: AppPadding(
        tPadding: 6.h,
        lPadding: 1.w,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              lines,
              animationText,
            ],
          ),
        ),
      ),
    );
  }

  Widget get lines => AppPadding(
        rPadding: 1.w,
        child: Text(
          controller.vsCodeLines.value,
          textAlign: TextAlign.right,
          style: AppTextStyles.codingTitle
              .copyWith(fontSize: 11.sp, color: AppColors.vsCodeLine),
        ),
      );

  Widget get animationText {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          controller.vsCodeText.length,
          textAnimation,
        ),
      ),
    );
  }

  Widget textAnimation(int index) {
    return Stack(
      children: [
        text(index),
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Obx(
              () => Opacity(
                opacity: controller.vsCodeText.length - 1 == index &&
                        controller.vsCodeText.last.value != '' &&
                        controller.cursorOpacity.value
                    ? 1
                    : 0,
                child: Container(
                  color: AppColors.white,
                  width: 2,
                  height: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget text(int index) {
    if (index == 0) {
      return Row(
        children: [
          SelectableText(
            controller.vsCodeText[index].value.nameSyntaxCheck(),
            style: AppTextStyles.codingTitle.copyWith(fontSize: 11.sp),
          ),
          MeasureSize(
            onChange: (size) {
              controller.nameTextSize = Size(
                size.width,
                size.height,
              ).obs;
            },
            child: SelectableText(
              controller.vsCodeText[index].value.nameCheck(),
              key: controller.textWidgetKey,
              style: AppTextStyles.title.copyWith(fontSize: 11.sp),
            ),
          ),
        ],
      );
    } else {
      return SelectableText(
        controller.vsCodeText[index].value,
        style: AppTextStyles.codingTitle.copyWith(fontSize: 11.sp),
      );
    }
  }
}
