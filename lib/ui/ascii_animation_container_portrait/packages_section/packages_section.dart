part of '../ascii_animation_container.dart';

class _PackagesSection extends StatelessWidget {
  const _PackagesSection({required this.packages});
  final List<Map<String, String>> packages;
  @override
  Widget build(BuildContext context) {
    return AppPadding(
      tPadding: 3.h,
      child: Wrap(
        children: packages.map((package) => packageWidget(package)).toList(),
      ),
    );
  }

  Widget packageWidget(Map<String, String> package) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => JavascriptService.openUrl(package['url']!),
        child: SizedBox(
          height: 32.5.h,
          width: 42.w,
          child: Padding(
            padding: const EdgeInsets.all(6),
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
                        SizedBox(
                          width: 33.w,
                          child: Text(
                            package['name']!,
                            style: GoogleFonts.martianMono(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AppPadding(
                        tPadding: 1.5.h,
                        child: publishedInfo(
                            package['published_time'] as String,
                            package['publisher'] as String),
                      ),
                    ),
                    platform(package['platforms'] as String),
                    content(package['readme_content'] as String),
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
            fontSize: 12.5.sp,
            color: Colors.white,
          ),
        ),
        Text(
          publisherName,
          style: GoogleFonts.martianMono(
            fontSize: 12.5.sp,
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
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: platforms,
                style: GoogleFonts.martianMono(
                  fontSize: 12.sp,
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
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
