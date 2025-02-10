part of '../ascii_animation_container.dart';

class _Projects extends StatelessWidget {
  const _Projects({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: topLine),
                Row(
                  children: [
                    Expanded(child: horizontalLine),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(child: horizontalLine),
                  ],
                ),
              ],
            )),
        Expanded(
          flex: 8,
          child: Row(
            children: [
              const Expanded(child: _ProjectSection()),
              verticalLine,
              const Expanded(child: _CompetitionsAndCertificatesSection()),
            ],
          ),
        ),
      ],
    );
  }

  Widget get topLine => AppPadding(
        lPadding: 1.w,
        rPadding: 1.w,
        bPadding: 0.3.w,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            title(AsciiConstants.projects),
            title(AsciiConstants.competitionsAndCertificates),
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
        fontSize: 8.1.sp,
        height: 1.1,
        letterSpacing: 0.05,
      );
}
