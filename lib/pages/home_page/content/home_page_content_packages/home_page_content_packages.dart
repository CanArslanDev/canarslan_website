part of '../../home_page.dart';

class _ContentPackages extends StatelessWidget {
  const _ContentPackages();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h),
      child: const Column(
        children: [_ContentPackagesTitle(), _ContentPackagesWidget()],
      ),
    );
  }
}
