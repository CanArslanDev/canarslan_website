part of '../../home_page.dart';

class _ContentInfoButtons extends StatelessWidget {
  const _ContentInfoButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      tPadding: 1.w,
      child: Row(
        children: [
          button('Contact Me', StringConstants.linkedin, ButtonType.primary),
          AppPadding(
            lPadding: 1.w,
            child: button('View My Projects',
                StringConstants.github.toGithubRepo, ButtonType.secondary),
          ),
        ],
      ),
    );
  }

  Widget button(String text, String url, ButtonType type) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => JavascriptService.openUrl(url),
          child: Container(
            height: 3.8.h,
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            decoration: BoxDecoration(
              color: type == ButtonType.primary
                  ? AppColors.lightBlue
                  : AppColors.white,
              borderRadius: AppBorderRadius.extraSmall,
              boxShadow: [
                BoxShadow(
                  color: type == ButtonType.primary
                      ? AppColors.lightBlue
                      : AppColors.white.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 0.4,
                )
              ],
            ),
            child: Center(
              child: Text(text,
                  style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 11.5.sp,
                      color: type == ButtonType.primary
                          ? AppColors.white
                          : AppColors.black)),
            ),
          ),
        ),
      );
}

enum ButtonType { primary, secondary }
