part of '../ascii_animation_container.dart';

class _CompetitionsAndCertificatesSection extends StatelessWidget {
  const _CompetitionsAndCertificatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPadding(
      rPadding: 1.w,
      lPadding: 1.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title(AsciiConstants.certificates),
          certificates,
          line,
          title(AsciiConstants.competitions),
          competitions
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
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                certificate('Computer Science', '', 'Harvard University',
                    'assets/images/harvard_university_logo.png', false),
                certificate('Elements Of AI', '', 'University Of Helsinki',
                    'assets/images/helsinki_university_logo.png', true),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                certificate('Artificial Intelligence', '', 'Harvard University',
                    'assets/images/harvard_university_logo.png', false),
                certificate(
                    'Computer Science for Business Professionals',
                    '',
                    'Harvard University',
                    'assets/images/harvard_university_logo.png',
                    true),
              ],
            ),
          )
        ],
      );

  Widget get competitions => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                certificate(
                    'Project Manager',
                    'Efficiency Challenge',
                    'Delta Cells',
                    'assets/images/delta_cells_project_logo.png',
                    false),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                certificate('Project Manager', 'Efficiency Challenge', 'Alaz',
                    'assets/images/alaz_project_logo.png', false),
                certificate(
                    'Project Manager',
                    'Technology for the Benefit of Humanity',
                    'AKUS',
                    'assets/images/akus_project_logo.png',
                    false,
                    imageWidth: 8.w),
              ],
            ),
          )
        ],
      );

  Widget certificate(
      String name, String tag, String organization, String imagePath, bool last,
      {double? imageWidth}) {
    return AppPadding(
      tPadding: last ? 1.w : 0.4.w,
      child: Row(
        children: [
          AppPadding(
            rPadding: 2.w,
            child: Image.asset(
              imagePath,
              width: imageWidth ?? 8.w,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.martianMono(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold),
                ),
                if (tag != '')
                  Text(
                    tag,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold),
                  ),
                Text(
                  organization,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget title(String title) => AppPadding(
        tPadding: 1.h,
        bPadding: 0.5.h,
        child: TitleAsciiArtText(
          finalAsciiText: title,
          animationDuration: Duration.zero,
          initialStepDuration: Duration.zero,
          fontSize: 9.sp,
          height: 1.1,
          letterSpacing: 0.05,
        ),
      );
}
