import 'package:canarslan_website/controllers/contact_page_controller/contact_page_controller.dart';
import 'package:canarslan_website/services/controller_service.dart';
import 'package:canarslan_website/ui/padding.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:canarslan_website/ui/utils/text_styles.dart';
import 'package:flutter/material.dart';
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
            height: 20.h,
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
            child: terminalText,
          ),
        ],
      ),
    );
  }

  Widget get terminalText => AppPadding(
        tPadding: 0.1.w,
        lPadding: 0.2.w,
        child: Text(
          'Last login: ${controller.date}',
          style: AppTextStyles.codingBody.copyWith(
            fontSize: 10.sp,
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
