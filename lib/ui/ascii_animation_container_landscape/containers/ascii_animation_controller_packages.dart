part of '../ascii_animation_container.dart';

class _Packages extends StatefulWidget {
  const _Packages({super.key});

  @override
  State<_Packages> createState() => _PackagesState();
}

class _PackagesState extends State<_Packages> {
  ValueNotifier<List<Map<String, String>>> packages = ValueNotifier([]);
  @override
  void initState() {
    Future(() async {
      packages.value = await HtmlService.fetchPackages(
          'https://pub.dev/publishers/canarslan.me/packages');
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        topSection,
        ValueListenableBuilder(
          valueListenable: packages,
          builder: (context, value, child) => packagesWidget(value),
        )
      ],
    );
  }

  Widget get topSection =>
      AppPadding(tPadding: 5.h, child: title(AsciiConstants.packages));

  Widget packagesWidget(List<Map<String, String>> packages) => _PackagesSection(
        packages: packages,
      );

  Widget title(String title) => TitleAsciiArtText(
        finalAsciiText: title,
        animationDuration: Duration.zero,
        initialStepDuration: Duration.zero,
        fontSize: 9.sp,
        height: 1.1,
        letterSpacing: 0.05,
      );
}
