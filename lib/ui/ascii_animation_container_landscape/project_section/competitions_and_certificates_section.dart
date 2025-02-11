part of '../ascii_animation_container.dart';

class _CompetitionsAndCertificatesSection extends StatelessWidget {
  const _CompetitionsAndCertificatesSection();

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      rPadding: 1.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppPadding(tPadding: 1.h, child: title(AsciiConstants.certificates)),
          certificates,
          line,
          AppPadding(tPadding: 1.h, child: title(AsciiConstants.competitions)),
          competitions,
        ],
      ),
    );
  }

  Widget get line => AppPadding(
        tPadding: 3.h,
        lPadding: 4.w,
        child: CustomPaint(
          size: Size(double.infinity, 0.1.h),
          painter: AsciiLinePainter(isHorizontalLine: true),
        ),
      );

  Widget get certificates => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                certificate(
                  'Computer Science',
                  '',
                  'Harvard University',
                  'assets/images/harvard_university_logo.png',
                  last: false,
                ),
                certificate(
                  'Elements Of AI',
                  '',
                  'University Of Helsinki',
                  'assets/images/helsinki_university_logo.png',
                  last: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                certificate(
                  'Artifical Intellegence',
                  '',
                  'Harvard University',
                  'assets/images/harvard_university_logo.png',
                  last: false,
                ),
                certificate(
                  'Computer Science for Business Professionals',
                  '',
                  'Harvard University',
                  'assets/images/harvard_university_logo.png',
                  last: true,
                ),
              ],
            ),
          ),
        ],
      );
  Widget get competitions => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                certificate(
                  'Project Manager',
                  'Efficiency Challenge',
                  'Delta Cells',
                  'assets/images/delta_cells_project_logo.png',
                  last: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                certificate(
                  'Project Manager',
                  'Efficiency Challenge',
                  'Alaz',
                  'assets/images/alaz_project_logo.png',
                  last: false,
                ),
                certificate(
                  'Project Manager',
                  'Technology for the Benefit of Humanity',
                  'AKUS',
                  'assets/images/akus_project_logo.png',
                  last: false,
                  imageWidth: 3.5.w,
                ),
              ],
            ),
          ),
        ],
      );

  Widget certificate(
    String name,
    String tag,
    String organization,
    String imagePath, {
    required bool last,
    double? imageWidth,
  }) {
    return AppPadding(
      tPadding: last ? 1.w : 0.4.w,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.martianMono(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (tag != '')
                  Text(
                    tag,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Text(
                  organization,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          AppPadding(
            lPadding: imageWidth != null ? 4.w - imageWidth : 0,
            child: Image.asset(
              imagePath,
              width: imageWidth ?? 4.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget title(String title) => TitleAsciiArtText(
        finalAsciiText: title,
        animationDuration: Duration.zero,
        initialStepDuration: Duration.zero,
        fontSize: 7.5.sp,
        height: 1.1,
        letterSpacing: 0.05,
      );
}
