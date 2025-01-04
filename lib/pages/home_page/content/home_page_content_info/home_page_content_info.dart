part of '../../home_page.dart';

class _ContentInfo extends StatelessWidget {
  const _ContentInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 27.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          texts,
          Image.asset(
            'assets/images/work_icon.png',
            height: 25.h,
          ),
        ],
      ),
    );
  }

  Widget get texts => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText.rich(
            TextSpan(
              style: AppTextStyles.codingBody,
              children: [
                const TextSpan(
                  text: "I'm currently working on",
                ),
                TextSpan(
                  text: '\nFlutter & Dart Developing',
                  style: AppTextStyles.codingBody.copyWith(
                    color: AppColors.blue,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const BoxShadow(
                        color: AppColors.blue,
                        blurRadius: 10,
                        spreadRadius: 1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0.5.h),
            child: SelectableText(
              'I also share my projects on my\nGithub profile.',
              maxLines: 2,
              style: AppTextStyles.codingBody.copyWith(fontSize: 12.sp),
            ),
          ),
          const _ContentInfoButtons(),
        ],
      );
}
