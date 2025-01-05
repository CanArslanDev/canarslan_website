part of '../../../home_page.dart';

class _AnimationTextLandscape extends StatefulWidget {
  const _AnimationTextLandscape();

  @override
  _AnimationTextLandscapeState createState() => _AnimationTextLandscapeState();
}

class _AnimationTextLandscapeState extends State<_AnimationTextLandscape>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ValueNotifier<bool> animationStarted = ValueNotifier<bool>(false);
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    Timer(const Duration(milliseconds: 1000), startAnimation);
  }

  void startAnimation() {
    animationStarted.value = true;
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: animationStarted,
        builder: (context, bool value, child) {
          return ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: const <Color>[
                  Colors.blue,
                  Colors.transparent,
                ],
                stops: value
                    ? <double>[
                        _animation.value,
                        1,
                      ]
                    : [0, 0],
              ).createShader(bounds);
            },
            child: Stack(
              children: [
                AnimatedOpacity(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 1000),
                  opacity: !value ? 0 : 1,
                  child: SelectableText(
                    StringConstants.name,
                    style: AppTextStyles.title.copyWith(
                      fontSize: OrientationService.isPortrait ? 18.sp : 11.sp,
                      color: Colors.blue,
                      shadows: [
                        const BoxShadow(
                          color: Colors.blue,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                SelectableText(
                  StringConstants.name,
                  style: AppTextStyles.title.copyWith(
                    fontSize: OrientationService.isPortrait ? 18.sp : 11.sp,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          );
        });
  }
}
