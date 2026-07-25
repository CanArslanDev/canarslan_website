import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

/// Edge-to-edge scrolling strip of value props, separated by accent `//`.
///
/// The track is laid out four times and translated by exactly one quarter, so
/// the loop is seamless and never gaps on ultra-wide screens.
class SignalMarquee extends StatefulWidget {
  const SignalMarquee({
    required this.items,
    super.key,
    this.duration = const Duration(seconds: 30),
  });

  final List<String> items;
  final Duration duration;

  @override
  State<SignalMarquee> createState() => _SignalMarqueeState();
}

class _SignalMarqueeState extends State<SignalMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !MediaQuery.disableAnimationsOf(context)) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final size = fluid(context.screenWidth, min: 26, max: 48);

    final track = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var pass = 0; pass < 4; pass++)
          for (final item in widget.items) ...[
            Text(
              item.toUpperCase(),
              style: TextStyle(
                fontFamily: SignalFonts.display,
                fontWeight: FontWeight.w700,
                fontSize: size,
                height: 1,
                letterSpacing: size * 0.01,
                color: palette.fg,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '//',
                style: TextStyle(
                  fontFamily: SignalFonts.mono,
                  fontSize: size * 0.62,
                  height: 1,
                  letterSpacing: size * 0.062,
                  color: palette.accentText,
                ),
              ),
            ),
          ],
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.surface,
        border: Border(bottom: BorderSide(color: palette.line)),
      ),
      child: SizedBox(
        // Explicit height, because the track below is laid out unbounded and
        // can no longer report an intrinsic one.
        height: size * 1.15 + 32,
        child: ClipRect(
          child: OverflowBox(
            alignment: Alignment.centerLeft,
            maxWidth: double.infinity,
            child: ExcludeSemantics(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FractionalTranslation(
                    translation: Offset(-_controller.value * 0.25, 0),
                    child: child,
                  );
                },
                child: track,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
