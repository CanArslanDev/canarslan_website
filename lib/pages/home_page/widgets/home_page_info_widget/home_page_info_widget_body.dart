part of '../../home_page.dart';

class _InfoWidgetBody extends GetView<HomePageController> {
  const _InfoWidgetBody();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: 20.w,
      decoration: BoxDecoration(
        color: AppColors.black.withValues(alpha: 0.4),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(color: AppColors.grey, width: 2),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            color: AppColors.grey.withValues(alpha: 0.5),
            spreadRadius: -3,
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          avatar,
          title,
          githubButton,
          Expanded(
            flex: 8,
            child: Column(
              children: [
                SizedBox(height: 1.6.h),
                text(StringConstants.location, AppIcons.location),
                text(
                  controller.time.convertClock,
                  AppIcons.clock,
                  hintText: '(UTC +${IntConstants.timezone}:00)',
                ),
                text(
                  StringConstants.email,
                  AppIcons.email,
                  url: 'mailto:${StringConstants.email}',
                ),
                text(
                  StringConstants.linkedin.linkedinTag,
                  AppIcons.linkediin,
                  url: StringConstants.linkedin,
                ),
                text(
                  StringConstants.x.xTag,
                  AppIcons.x,
                  url: StringConstants.x,
                ),
                text(
                  StringConstants.instagram.instagramTag,
                  AppIcons.instagram,
                  url: StringConstants.instagram,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget text(String text, String iconpath, {String? url, String? hintText}) =>
      Padding(
        padding: EdgeInsets.only(left: 2.w, top: 0.8.h, bottom: 0.8.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IntrinsicWidth(
            child: Row(
              children: [
                SvgPicture.asset(
                  iconpath,
                  height: 2.5.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 0.5.w),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: SelectableText.rich(
                        TextSpan(
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.white,
                            fontSize: 11.7.sp,
                          ),
                          children: [
                            TextSpan(text: text),
                            if (hintText != null)
                              TextSpan(
                                text: ' $hintText ',
                                style: AppTextStyles.body.copyWith(
                                  color: AppColors.lightGrey,
                                  fontSize: 11.7.sp,
                                  fontWeight: FontWeight.w600,
                                ),
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
                          height: 2.h,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

  Widget get githubButton => Expanded(
        flex: 2,
        child: Center(
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            height: 4.4.h,
            child: TextButton(
              onPressed: () =>
                  JavascriptService.openUrl(StringConstants.github),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(AppColors.lightBlue),
                shape: WidgetStateProperty.all(
                  const RoundedRectangleBorder(
                    borderRadius: AppBorderRadius.small,
                  ),
                ),
              ),
              child: RichText(
                text: TextSpan(
                  style:
                      AppTextStyles.bodyBold.copyWith(color: AppColors.white),
                  children: [
                    TextSpan(
                      text: 'View on ',
                      style: AppTextStyles.body.copyWith(fontSize: 11.sp),
                    ),
                    const TextSpan(text: 'Github'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget get avatar => Expanded(
        flex: 5,
        child: Container(
          margin: EdgeInsets.all(2.h),
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
        flex: 2,
        child: Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  StringConstants.name,
                  style: AppTextStyles.title.copyWith(
                    color: AppColors.white,
                    fontSize: 15.sp,
                  ),
                ),
                SelectableText(
                  StringConstants.tag,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.lightGrey,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
