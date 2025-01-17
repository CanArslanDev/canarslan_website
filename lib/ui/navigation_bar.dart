import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/navigation_bar_controller/navigation_bar_controller.dart';
import 'package:canarslan_website/extensions/string_extension.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:canarslan_website/services/route_service.dart';
import 'package:canarslan_website/ui/border_radius.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:canarslan_website/ui/utils/text_styles.dart';
import 'package:canarslan_website/ui/widgets/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'dart:html' as html;

class NavBar extends GetView<NavigationBarController> {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final width = OrientationService.isPortrait ? 80.w : 37.w;
    return Positioned(
      left: 100.w / 2 - width / 2,
      top: -9.h,
      child: Obx(
        () => SizedBox(
          height: 15.7.h,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 2500),
            curve: Curves.fastLinearToSlowEaseIn,
            alignment: controller.openNavbar.value
                ? Alignment.bottomCenter
                : Alignment.topCenter,
            child: Container(
              height: 4.7.h,
              width: width,
              decoration: BoxDecoration(
                  color: AppColors.black.withOpacity(0.4),
                  borderRadius: AppBorderRadius.medium,
                  border: Border.all(color: AppColors.grey, width: 2),
                  boxShadow: [
                    BoxShadow(
                      blurStyle: BlurStyle.outer,
                      color: AppColors.grey.withOpacity(0.5),
                      spreadRadius: -3,
                      blurRadius: 10,
                    ),
                  ]),
              child: Stack(
                children: [
                  Row(
                    children: [
                      item('Home', 'home', 0),
                      item(
                        'Projects & Packages',
                        'projects',
                        1,
                      ),
                      item(
                        'Contact',
                        'contact',
                        2,
                      ),
                    ],
                  ),
                  Positioned.fill(
                      child: Align(
                    alignment: Alignment.centerLeft,
                    child: Obx(() => AnimatedContainer(
                          margin: EdgeInsets.only(
                              left: 5.5.sp +
                                  controller.selectedPage.value *
                                      controller.menuItemSize.value.width,
                              right: 5.5.sp,
                              top: 5.5.sp,
                              bottom: 5.5.sp),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryWhite
                                .withValues(alpha: 0.12),
                            borderRadius: AppBorderRadius.medium,
                          ),
                          height: controller.menuItemSize.value.height,
                          width: controller.menuItemSize.value.width,
                          duration: const Duration(seconds: 2),
                          curve: Curves.fastLinearToSlowEaseIn,
                        )),
                  ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget item(
    String title,
    String id,
    int index,
  ) =>
      Expanded(
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // if (url != null) {
              //   JavascriptService.openUrl(url);
              //   return;
              // }
              controller.changePage(index);

              RouteService.setHref(id);
            },
            child: Obx(() => MeasureSize(
                  onChange: (size) {
                    controller.menuItemSize.value = size;
                  },
                  child: Container(
                    margin: EdgeInsets.all(5.5.sp),
                    decoration: BoxDecoration(
                      color:
                          controller.selectedPage.value == index ? null : null,
                      borderRadius: AppBorderRadius.medium,
                    ),
                    child: Center(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.navBar,
                      ),
                    ),
                  ),
                )),
          ),
        ),
      );
}
