part of '../home_page.dart';

class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _DisposeAnimationTitle(),
        const _ContentInfo(),
        const _ContentPackages(),
        if (OrientationService.isPortrait) const _ContentInfoWidget(),
        const _ContentContributions()
      ],
    );
  }
}
