part of '../contact_page.dart';

class _TerminalText extends GetView<ContactPageController> {
  const _TerminalText({
    required this.text,
    required this.urlText,
    required this.url,
    required this.color,
    required this.cursor,
  });
  final Rx<String> text;
  final String urlText;
  final String url;
  final Color color;
  final int cursor;

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      tPadding: 0.1.w,
      lPadding: 0.2.w,
      child: Obx(
        () => SelectableText.rich(
          TextSpan(
            style: AppTextStyles.codingBody.copyWith(
              fontSize: OrientationService.contactPageTextFontSize,
            ),
            children: [
              TextSpan(
                  text: text.value.substring(
                      0,
                      (controller.defaultText[0].length > text.value.length
                          ? text.value.length
                          : controller.defaultText[0].length))),
              if (text.value.length > controller.defaultText[0].length + 1)
                TextSpan(
                  text: text.value.substring(
                      controller.defaultText[0].length + 1,
                      (controller.defaultText[0].length + urlText.length + 1 <
                              text.value.length)
                          ? controller.defaultText[0].length +
                              urlText.length +
                              1
                          : text.value.length),
                  style: AppTextStyles.codingBody.copyWith(
                      fontSize: OrientationService.contactPageTextFontSize,
                      color: color,
                      decoration: TextDecoration.underline,
                      decorationColor: color,
                      decorationThickness: 3,
                      shadows: [
                        BoxShadow(
                            color: color, blurRadius: 10, spreadRadius: 10),
                      ]),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => JavascriptService.openUrl(url),
                ),
              if (controller.defaultText[0].length + urlText.length + 2 <
                  text.value.length)
                TextSpan(
                  text: text.value.substring(
                    controller.defaultText[0].length + urlText.length + 2,
                  ),
                ),
              if (controller.cursorTextAnimation.value == cursor &&
                  controller.cursorAnimation.value)
                WidgetSpan(
                    child: Container(
                  width: 0.4.w,
                  height: 1.8.h,
                  decoration: const BoxDecoration(
                    color: AppColors.lightGrey,
                  ),
                ))
            ],
          ),
        ),
      ),
    );
  }
}
