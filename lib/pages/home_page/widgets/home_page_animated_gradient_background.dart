part of '../home_page.dart';

class _GradientBackgroundAnimation extends StatefulWidget {
  const _GradientBackgroundAnimation({super.key});

  @override
  _GradientBackgroundAnimationState createState() =>
      _GradientBackgroundAnimationState();
}

class _GradientBackgroundAnimationState
    extends State<_GradientBackgroundAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _radiusXAnimation;
  late Animation<double> _radiusYAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _radiusXAnimation = Tween<double>(begin: 0.1, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _radiusYAnimation = Tween<double>(begin: 0.1, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: HomePageController(),
      builder: (controller) {
        return Obx(() {
          if (controller.wallpaperAnimation.value) {
            Timer(
                const Duration(milliseconds: 100), () => _controller.forward());
          }
          return body;
        });
      },
    );
  }

  Widget get body => AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return RadialGradient(
                  center: Alignment.center,
                  radius: _radiusXAnimation.value,
                  focalRadius: _radiusYAnimation.value,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.1, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                width: Get.width,
                height: Get.height,
                child: mainWallpaper,
              ),
            ),
          );
        },
      );

  Widget get mainWallpaper => Image.asset(
        'assets/images/main_wallpaper.png',
        fit: BoxFit.fitHeight,
      );
}
