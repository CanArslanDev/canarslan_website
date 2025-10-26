part of '../ascii_animation_container.dart';

class _PackagesSection extends StatelessWidget {
  const _PackagesSection({required this.packages});
  final List<Map<String, String>> packages;
  @override
  Widget build(BuildContext context) {
    return AppPadding(
      tPadding: 3.h,
      child: Wrap(
        spacing: 1.w,
        children: packages.map(packageWidget).toList(),
      ),
    );
  }

  Widget packageWidget(Map<String, String> package) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => JavascriptService.openUrl(package['url']!),
        child: SizedBox(
          height: 55.h,
          width: 25.w,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: CustomPaint(
              painter: PackagePainter(borderRadius: 15),
              child: AppPadding(
                tPadding: 11.sp,
                lPadding: 12.sp,
                rPadding: 12.sp,
                bPadding: 12.sp,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          package['name']!,
                          style: GoogleFonts.martianMono(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Dart 3',
                          style: GoogleFonts.martianMono(
                            fontSize: 10.5.sp,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    AppPadding(
                      tPadding: 1.5.h,
                      child: Row(
                        children: [
                          publishedInfo(
                            package['published_time']!,
                            package['publisher']!,
                          ),
                          const Spacer(),
                          specs(
                            package['likes']!,
                            package['points']!,
                            package['downloads']!,
                          ),
                        ],
                      ),
                    ),
                    platform(package['platforms']!),
                    content(package['readme_content']!),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget publishedInfo(String publishedDate, String publisherName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          publishedDate,
          style: GoogleFonts.martianMono(
            fontSize: 9.5.sp,
            color: Colors.white,
          ),
        ),
        Text(
          publisherName,
          style: GoogleFonts.martianMono(
            fontSize: 9.5.sp,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget specs(String likes, String points, String downloads) {
    Widget section(String title, String value) {
      return AppPadding(
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.martianMono(
                fontSize: 9.5.sp,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.martianMono(
                fontSize: 9.5.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      spacing: 12,
      children: [
        section('Likes', likes),
        section('Points', points),
        section('Downloads', downloads),
      ],
    );
  }

  Widget platform(String platforms) {
    return AppPadding(
      tPadding: 1.5.h,
      child: Align(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Platforms: ',
                style: GoogleFonts.martianMono(
                  fontSize: 9.3.sp,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: platforms,
                style: GoogleFonts.martianMono(
                  fontSize: 9.3.sp,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget content(String content) {
    return Expanded(
      child: AppPadding(
        tPadding: 1.5.h,
        child: Text(
          content,
          style: GoogleFonts.martianMono(
            fontSize: 9.5.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
