part of '../home_page.dart';

class _Content extends StatelessWidget {
  const _Content({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned.fill(
        child: Center(
      child: Column(
        children: [
          _ContentInfo(),
        ],
      ),
    ));
  }
}
