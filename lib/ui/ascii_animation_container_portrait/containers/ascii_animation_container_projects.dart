part of '../ascii_animation_container.dart';

class _Projects extends StatelessWidget {
  const _Projects();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topLine,
        const _ProjectSection(),
        const _CompetitionsAndCertificatesSection(),
      ],
    );
  }

  Widget get topLine => AppPadding(
        tPadding: 1.h,
        lPadding: 1.w,
        rPadding: 1.w,
        bPadding: 0.3.w,
        child: Row(
          children: [
            title(AsciiConstants.projects),
          ],
        ),
      );

  Widget get verticalLine => CustomPaint(
        size: const Size(
          6,
          double.infinity,
        ),
        painter: AsciiLinePainter(isVerticalLine: true),
      );

  Widget get horizontalLine => CustomPaint(
        size: const Size(
          double.infinity,
          6,
        ),
        painter: AsciiLinePainter(isHorizontalLine: true),
      );

  Widget title(String title) => TitleAsciiArtText(
        finalAsciiText: title,
        animationDuration: Duration.zero,
        initialStepDuration: Duration.zero,
        fontSize: 10.sp,
        height: 1.1,
        letterSpacing: 0.05,
      );
}
