part of '../contact_page.dart';

class _Terminal extends StatelessWidget {
  const _Terminal({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppPadding(
          tPadding: 15.h,
          child: Center(
            child: Container(
              width: 80.w,
              height: 3.h,
              decoration: decoration,
              child: Stack(
                children: [
                  circles,
                  terminalTitle,
                ],
              ),
            ),
          ),
        ),
        terminalBody,
      ],
    );
  }

  BoxDecoration get decoration => const BoxDecoration(
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
      ));

  Widget get terminalTitle => Center(
        child: Text('canarslan.me website guest',
            style: AppTextStyles.title.copyWith(
              color: const Color(0xFFa2a4a8),
              fontSize: OrientationService.contactPageTitleFontSize,
            )),
      );

  Widget get terminalBody => Container(
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
        child: child,
      );

  Widget get circles => SizedBox(
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
      );

  Widget circle(Color color) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: OrientationService.contactPageCircleMargin),
      width: 1.2.h,
      height: 1.2.h,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
