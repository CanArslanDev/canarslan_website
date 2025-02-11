import 'package:canarslan_website/constants/string_constants.dart';
import 'package:canarslan_website/controllers/contact_page_controller/contact_page_controller.dart';
import 'package:canarslan_website/services/controller_service.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:canarslan_website/ui/padding.dart';
import 'package:canarslan_website/ui/utils/colors.dart';
import 'package:canarslan_website/ui/utils/text_styles.dart';
import 'package:canarslan_website/ui/vhs_effect.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
part 'widgets/contact_page_welcome_text.dart';
part 'widgets/contact_page_terminal_text.dart';
part 'widgets/contact_page_terminal.dart';

class ContactPage extends GetView<ContactPageController> {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    ControllerService.putFirstPageController();
    return Scaffold(
      backgroundColor: AppColors.black,
      body: VHSEffect(
        child: _Terminal(child: texts),
      ),
    );
  }

  Widget get texts => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _WelcomeText(),
          _TerminalText(
            text: controller.linkedInTextAnimation,
            urlText: controller.urlNames[0],
            url: StringConstants.linkedin,
            color: AppColors.lightBlue,
            cursor: 1,
          ),
          _TerminalText(
            text: controller.githubTextAnimation,
            urlText: controller.urlNames[1],
            url: StringConstants.github,
            color: AppColors.blue,
            cursor: 2,
          ),
          _TerminalText(
            text: controller.xTextAnimation,
            urlText: controller.urlNames[2],
            url: StringConstants.x,
            color: AppColors.lightGrey,
            cursor: 3,
          ),
        ],
      );
}
