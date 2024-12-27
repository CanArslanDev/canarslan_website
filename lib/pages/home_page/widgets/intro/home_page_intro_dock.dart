part of '../../home_page.dart';

class _Dock extends StatelessWidget {
  const _Dock();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: AppPadding(
        bPadding: 1.h,
        child: Image.asset(
          'assets/images/dock template.png',
          fit: BoxFit.fitHeight,
          height: 8.h,
        ),
      ),
    );
  }
}
