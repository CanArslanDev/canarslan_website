part of '../../../home_page.dart';

class _Notes extends GetView<HomePageController> {
  const _Notes({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      color: AppColors.notesBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          top,
          animatedText,
          spacer,
          bottom,
        ],
      ),
    );
  }

  Widget get top => Padding(
        padding: EdgeInsets.only(top: 3.h),
        child: Image.asset(
          'assets/images/notes template top.png',
          fit: BoxFit.fitWidth,
          width: 100.w,
        ),
      );

  Widget get spacer => const Spacer();

  Widget get bottom => Image.asset(
        'assets/images/notes template bottom.png',
        fit: BoxFit.fitWidth,
        width: 100.w,
      );
  Widget get animatedText => const _IntroTextPortrait();
}
