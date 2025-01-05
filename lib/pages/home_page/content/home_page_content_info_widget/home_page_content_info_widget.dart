part of '../../home_page.dart';

class _ContentInfoWidget extends GetView<HomePageController> {
  const _ContentInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        opacity: controller.contentVisibleList[6] == 1 ? 1 : 0,
        child: Container(
          width: 80.w,
          margin: EdgeInsets.only(top: 6.h),
          decoration: BoxDecoration(
              color: AppColors.black.withOpacity(0.4),
              borderRadius: AppBorderRadius.small,
              border: Border.all(color: AppColors.grey, width: 2),
              boxShadow: [
                BoxShadow(
                  blurStyle: BlurStyle.outer,
                  color: AppColors.grey.withOpacity(0.5),
                  spreadRadius: -3,
                  blurRadius: 10,
                ),
              ]),
          child: Column(
            children: [
              avatar,
              developerTag,
              Column(
                children: [
                  SizedBox(height: 1.6.h),
                  text(StringConstants.location, AppIcons.location),
                  text(
                    controller.time.convertClock,
                    AppIcons.clock,
                    hintText: '(UTC +${IntConstants.timezone}:00)',
                  ),
                  text(StringConstants.email, AppIcons.email,
                      url: 'mailto:${StringConstants.email}'),
                  text(StringConstants.linkedin.linkedinTag, AppIcons.linkediin,
                      url: StringConstants.linkedin),
                  text(StringConstants.x.xTag, AppIcons.x,
                      url: StringConstants.x),
                  text(StringConstants.instagram.instagramTag,
                      AppIcons.instagram,
                      url: StringConstants.instagram),
                ],
              ),
              githubButton,
            ],
          ),
        ),
      ),
    );
  }

  Widget get developerTag => Padding(
        padding: EdgeInsets.only(left: 5.w),
        child: Align(
          alignment: Alignment.centerLeft,
          child: SelectableText(
            StringConstants.developerTag,
            style: AppTextStyles.title.copyWith(
              color: AppColors.white,
              fontSize: 18.sp,
            ),
          ),
        ),
      );
  Widget text(String text, String iconpath, {String? url, String? hintText}) =>
      Padding(
        padding: EdgeInsets.only(left: 5.w, bottom: 0.8.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IntrinsicWidth(
            child: Row(
              children: [
                SvgPicture.asset(
                  iconpath,
                  height: 2.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 3.w),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SelectableText.rich(
                        TextSpan(
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.white,
                            fontSize: 16.sp,
                          ),
                          children: [
                            TextSpan(text: '$text'),
                            if (hintText != null)
                              TextSpan(
                                text: ' $hintText ',
                                style: AppTextStyles.body.copyWith(
                                    color: AppColors.lightGrey,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (url != null)
                  Padding(
                    padding: EdgeInsets.only(left: 0.5.w),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => JavascriptService.openUrl(url),
                        child: SvgPicture.asset(
                          AppIcons.openUrl,
                          height: 1.5.h,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Widget get githubButton => Center(
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
          height: 4.h,
          child: TextButton(
            onPressed: () => JavascriptService.openUrl(StringConstants.github),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.blue),
              shape: WidgetStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: AppBorderRadius.small,
                ),
              ),
            ),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyBold
                    .copyWith(color: AppColors.white, fontSize: 15.sp),
                children: [
                  TextSpan(
                    text: 'View on ',
                  ),
                  const TextSpan(text: 'Github'),
                ],
              ),
            ),
          ),
        ),
      );

  Widget get avatar => SizedBox(
        height: 10.h,
        child: Row(
          children: [
            image,
            title,
          ],
        ),
      );

  Widget get image => Expanded(
        flex: 2,
        child: Container(
          margin: EdgeInsets.only(left: 5.w),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/avatar.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

  Widget get title => Expanded(
        flex: 7,
        child: Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  StringConstants.name,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.white,
                    fontSize: 18.sp,
                  ),
                ),
                SelectableText(
                  StringConstants.tag,
                  style: AppTextStyles.body.copyWith(
                      color: AppColors.lightGrey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      );
}
