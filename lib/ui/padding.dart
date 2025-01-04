import 'package:flutter/widgets.dart';

class AppPadding extends StatelessWidget {
  const AppPadding({
    super.key,
    this.tPadding,
    this.rPadding,
    this.bPadding,
    this.lPadding,
    this.child,
  });
  final double? tPadding;
  final double? rPadding;
  final double? bPadding;
  final double? lPadding;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: tPadding ?? 0.0,
        right: rPadding ?? 0.0,
        bottom: bPadding ?? 0.0,
        left: lPadding ?? 0.0,
      ),
      child: child,
    );
  }
}
