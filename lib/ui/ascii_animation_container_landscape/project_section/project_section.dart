part of '../ascii_animation_container.dart';

class _ProjectSection extends StatelessWidget {
  const _ProjectSection();

  @override
  Widget build(BuildContext context) {
    final projects = ValueNotifier<List<Map<String, dynamic>>>([]);
    final viewProjects = ValueNotifier<List<Map<String, dynamic>>>([]);
    final pageCount = ValueNotifier<int>(0);
    void selectPage(int page) {
      viewProjects.value = projects.value.skip(page * 7).take(7).toList();
      pageCount.value = page;
    }

    void nextPage() {
      if ((pageCount.value + 1) * 7 < projects.value.length) {
        pageCount.value++;
        selectPage(pageCount.value);
      }
    }

    void previousPage() {
      if (pageCount.value == 0) {
        return;
      }
      pageCount.value--;
      selectPage(pageCount.value);
    }

    unawaited(
      Future(() async {
        projects.value =
            await HtmlService().fetchGitHubRepositories('CanArslanDev');
        selectPage(pageCount.value);
      }),
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder(
          valueListenable: viewProjects,
          builder: (context, value, child) {
            if (viewProjects.value.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < viewProjects.value.length; i++)
                  section(
                    value[i]['name'] as String,
                    value[i]['description'] == 'Unknown'
                        ? value[i]['updated_at'] as String
                        : value[i]['description'] as String,
                    value[i]['language'] as String,
                    !value[i]['color'].toString().startsWith('#')
                        ? Colors.white
                        : Color(
                            int.parse(
                              '''0xFF${(value[i]['color'] as String).substring(1, 7)}''',
                            ),
                          ),
                    int.parse(value[i]['stars'] as String),
                    last: value[i] == value.last,
                  ),
              ],
            );
          },
        ),
        AppPadding(
          bPadding: 2.h,
          child: ValueListenableBuilder(
            valueListenable: pageCount,
            builder: (context, value, child) => menuNavigation(
              value,
              previousPage,
              nextPage,
            ),
          ),
        ),
      ],
    );
  }

  Widget menuNavigation(
    int pageCount,
    void Function() previousPage,
    void Function() nextPage,
  ) =>
      AppPadding(
        tPadding: 1.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: previousPage,
                child: Container(
                  height: 3.h,
                  width: 1.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 10.sp,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0.2.w),
              margin: EdgeInsets.symmetric(horizontal: 0.4.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Colors.white,
              ),
              child: Text(
                (pageCount + 1).toString(),
                style: GoogleFonts.martianMono(
                  color: const Color(0xFF071235),
                  fontSize: 12.sp,
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: nextPage,
                child: Container(
                  height: 3.h,
                  width: 1.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 10.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget section(
    String title,
    String description,
    String language,
    Color languageColor,
    int starCount, {
    required bool last,
  }) {
    return AppPadding(
      lPadding: 1.w,
      rPadding: 2.w,
      child: Column(
        children: [
          AppPadding(
            tPadding: 1.7.h,
            bPadding: 1.7.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: title,
                            ),
                            WidgetSpan(
                              child: Container(
                                margin: EdgeInsets.only(left: 0.5.w),
                                padding:
                                    EdgeInsets.symmetric(horizontal: 0.3.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Text(
                                  'Public',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 10.5.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 11.5.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.martianMono(
                          color: Colors.white,
                          fontSize: 11.sp,
                        ),
                        children: [
                          const TextSpan(
                            text: 'Language: ',
                          ),
                          TextSpan(
                            text: language,
                            style: GoogleFonts.martianMono(
                              color: languageColor,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/star.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          height: 2.7.h,
                        ),
                        AppPadding(
                          lPadding: 0.2.w,
                          child: Text(
                            starCount.toString(),
                            style: GoogleFonts.martianMono(
                              color: Colors.white,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppPadding(
            rPadding: 2.5.w,
            child: CustomPaint(
              size: Size(double.infinity, 0.1.h),
              painter: AsciiLinePainter(isHorizontalLine: true),
            ),
          ),
        ],
      ),
    );
  }
}
