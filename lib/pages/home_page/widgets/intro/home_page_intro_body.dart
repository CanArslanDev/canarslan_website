part of '../../home_page.dart';

class _IntroBody extends StatelessWidget {
  const _IntroBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        sizedBox,
        const _VsCode(),
        const _Dock(),
      ],
    );
  }

  Widget get sizedBox => const SizedBox.shrink();
}
