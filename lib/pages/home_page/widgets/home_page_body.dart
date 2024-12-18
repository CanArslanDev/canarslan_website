part of '../home_page.dart';

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background,
        intro,
      ],
    );
  }

  Widget get intro => const _IntroBody();

  Widget get background => const SizedBox.expand(child: _Background());
}
