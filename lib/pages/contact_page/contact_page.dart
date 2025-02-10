import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/contact_page_controller/contact_page_controller.dart';
import 'package:canarslan_website/services/controller_service.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/ui/padding.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:canarslan_website/ui/utils/text_styles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ContactPage extends GetView<ContactPageController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    ControllerService.putFirstPageController();
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),
          Center(
            child: Container(
              width: 80.w,
              height: 3.h,
              decoration: const BoxDecoration(
                  color: Color(0xFF393a3f),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.lightGrey,
                    ),
                    left: BorderSide(
                      color: AppColors.lightGrey,
                    ),
                    right: BorderSide(
                      color: AppColors.lightGrey,
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  )),
              child: Stack(
                children: [
                  SizedBox(
                    height: 3.h,
                    child: AppPadding(
                      lPadding: 0.5.w,
                      child: Row(
                        children: [
                          circle(AppColors.red),
                          circle(AppColors.yellow),
                          circle(AppColors.green),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text('canarslan.me website guest',
                        style: AppTextStyles.title.copyWith(
                          color: const Color(0xFFa2a4a8),
                          fontSize: 10.sp,
                        )),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 80.w,
            height: 70.h,
            decoration: const BoxDecoration(
                color: Color(0xFF1c1d1c),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                border: Border(
                  top: BorderSide(
                    color: AppColors.black,
                  ),
                )),
            child: texts,
          ),
        ],
      ),
    );
  }

  Widget get texts => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          terminalText,
          terminalUrlText(
              controller.linkedInTextAnimation,
              controller.urlNames[0],
              StringConstants.linkedin,
              AppColors.lightBlue,
              1),
          terminalUrlText(
              controller.githubTextAnimation,
              controller.urlNames[1],
              StringConstants.github,
              AppColors.blue,
              2),
          terminalUrlText(controller.xTextAnimation, controller.urlNames[2],
              StringConstants.x, AppColors.lightGrey, 3),
        ],
      );
  Widget get terminalText => AppPadding(
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
                    fontSize: 10.sp,
                  ),
                ),
              ),
              if (controller.cursorTextAnimation.value == 0)
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Text(
                        controller.welcomeTextAnimation.value.split('\n').last,
                        style: AppTextStyles.codingBody.copyWith(
                            fontSize: 10.sp, color: Colors.transparent),
                      ),
                      Container(
                        width: 0.4.w,
                        height: 1.8.h,
                        decoration: const BoxDecoration(
                          color: AppColors.lightGrey,
                        ),
                      ),
                    ],
                  ),
                ))
            ],
          ),
        ),
      );

  Widget terminalUrlText(Rx<String> text, String urlText, String url,
          Color color, int cursor) =>
      AppPadding(
        tPadding: 0.1.w,
        lPadding: 0.2.w,
        child: Obx(
          () => SelectableText.rich(
            TextSpan(
              style: AppTextStyles.codingBody.copyWith(
                fontSize: 10.sp,
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
                        fontSize: 10.sp,
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
                if (controller.cursorTextAnimation.value == cursor)
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
  Widget get githubText => AppPadding(
        tPadding: 0.1.w,
        lPadding: 0.2.w,
        child: SelectableText.rich(
          TextSpan(
            style: AppTextStyles.codingBody.copyWith(
              fontSize: 10.sp,
            ),
            children: [
              const TextSpan(text: 'This is my '),
              TextSpan(
                text: 'Github',
                style: AppTextStyles.codingBody.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.blue,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.blue,
                    decorationThickness: 3,
                    shadows: [
                      const BoxShadow(
                          color: AppColors.blue,
                          blurRadius: 10,
                          spreadRadius: 10),
                    ]),
                recognizer: TapGestureRecognizer()
                  ..onTap =
                      () => JavascriptService.openUrl(StringConstants.github),
              ),
              const TextSpan(
                  text:
                      ''' profile\nYou can also access my other projects here!\n'''),
            ],
          ),
        ),
      );
  Widget get xText => AppPadding(
        tPadding: 0.1.w,
        lPadding: 0.2.w,
        child: SelectableText.rich(
          TextSpan(
            style: AppTextStyles.codingBody.copyWith(
              fontSize: 10.sp,
            ),
            children: [
              const TextSpan(text: 'This is my '),
              TextSpan(
                text: 'X',
                style: AppTextStyles.codingBody.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.vsCodeLine,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.vsCodeLine,
                    decorationThickness: 3,
                    shadows: [
                      const BoxShadow(
                          color: AppColors.vsCodeLine,
                          blurRadius: 10,
                          spreadRadius: 10),
                    ]),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => JavascriptService.openUrl(StringConstants.x),
              ),
              const TextSpan(text: ''' profile\n'''),
            ],
          ),
        ),
      );

  Widget circle(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.1.w),
      width: 1.2.h,
      height: 1.2.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
