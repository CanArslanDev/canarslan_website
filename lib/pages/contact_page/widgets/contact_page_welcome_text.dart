part of '../contact_page.dart';

class _WelcomeText extends GetView<ContactPageController> {
  const _WelcomeText();

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      tPadding: 0.1.w,
      lPadding: 0.2.w,
      child: Obx(
        () => Stack(
          children: [
            SizedBox(
              width: 90.h,
              child: SelectableText(
                controller.welcomeTextAnimation.value,
                style: AppTextStyles.codingBody.copyWith(
                  fontSize: OrientationService.contactPageTextFontSize,
                ),
              ),
            ),
            if (controller.cursorTextAnimation.value == 0)
              Positioned.fill(
                  child: Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: 70.h,
                  child: SelectableText.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: controller.welcomeTextAnimation.value
                              .split('\n')
                              .last,
                          style: AppTextStyles.codingBody.copyWith(
                            fontSize:
                                OrientationService.contactPageTextFontSize,
                            color: Colors.transparent,
                          ),
                        ),
                        if (controller.cursorAnimation.value)
                          WidgetSpan(
                            child: Container(
                              width: 0.4.w,
                              height: 1.8.h,
                              decoration: const BoxDecoration(
                                color: AppColors.lightGrey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),),
          ],
        ),
      ),
    );
  }
}
