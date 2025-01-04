part of '../home_page.dart';

class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [_ContentInfo(), _ContentPackages(), _ContentContributions()],
    );
  }
}
