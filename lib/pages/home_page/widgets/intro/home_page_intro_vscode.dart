part of '../../home_page.dart';

class _VsCode extends StatelessWidget {
  const _VsCode();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/vscode template.png',
          fit: BoxFit.fitWidth,
          width: 30.w,
        ),
        const Positioned.fill(child: _IntroText()),
      ],
    );
  }
}
