part of '../../../home_page.dart';

class _Notes extends GetView<HomePageController> {
  const _Notes();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      color: AppColors.notesBackground,
      child: Column(
        children: [
          top,
          animatedText,
          spacer,
          bottom,
        ],
      ),
    );
  }

  Widget noteIcon(String path) => SvgPicture.asset(
        path,
        width: 5.5.w,
        height: 5.5.w,
        colorFilter:
            const ColorFilter.mode(AppColors.notesYellow, BlendMode.srcIn),
      );

  Widget get top => AppPadding(
        tPadding: 5.1.h,
        lPadding: 1.w,
        child: Row(
          children: [
            const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppColors.notesYellow,
            ),
            Text(
              'Notes',
              style: AppTextStyles.regular.copyWith(
                color: AppColors.notesYellow,
                fontSize: 18.sp,
              ),
            ),
            const Spacer(),
            AppPadding(
                rPadding: 5.w,
                child: noteIcon('assets/icons/notes/notes_more.svg'),),
          ],
        ),
      );

  Widget get spacer => const Spacer();

  Widget get bottom => AppPadding(
        bPadding: 2.1.h,
        rPadding: 2.6.h,
        lPadding: 2.6.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            noteIcon('assets/icons/notes/notes_done.svg'),
            noteIcon('assets/icons/notes/notes_camera.svg'),
            noteIcon('assets/icons/notes/notes_location.svg'),
            noteIcon('assets/icons/notes/notes_edit.svg'),
          ],
        ),
      );
  Widget get animatedText => const _IntroTextPortrait();
}
