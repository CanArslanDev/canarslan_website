import 'dart:math' as math;

import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:flutter/widgets.dart';

/// Text that settles out of character noise into its final word.
///
/// This is the one motif carried over from the old site — the ASCII title
/// animation — rebuilt as a reusable primitive. It drives section stamps on
/// reveal and the hover glitch on data rows.
class SignalScrambleText extends StatefulWidget {
  const SignalScrambleText(
    this.text, {
    super.key,
    this.style,
    this.duration = SignalMotion.scramble,
    this.play = true,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final TextStyle? style;
  final Duration duration;

  /// Flip from false to true to run the animation. Flipping back and forth
  /// replays it — that is how the row hover glitch works.
  final bool play;

  final TextAlign? textAlign;
  final int? maxLines;

  @override
  State<SignalScrambleText> createState() => _SignalScrambleTextState();
}

class _SignalScrambleTextState extends State<SignalScrambleText>
    with SingleTickerProviderStateMixin {
  static const String _glyphs = r'01<>[]{}/\|=+*#%@$&';

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  final math.Random _random = math.Random();
  String _rendered = '';

  @override
  void initState() {
    super.initState();
    _rendered = widget.text;
    _controller.addListener(_onTick);
    if (widget.play) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _start());
    }
  }

  @override
  void didUpdateWidget(SignalScrambleText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) _rendered = widget.text;
    if (widget.play && !oldWidget.play) _start();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTick)
      ..dispose();
    super.dispose();
  }

  void _start() {
    if (!mounted) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      setState(() => _rendered = widget.text);
      return;
    }
    _controller.forward(from: 0);
  }

  void _onTick() {
    final progress = _controller.value;
    final target = widget.text;
    // Squared progress settles the opening characters slowly and the tail
    // fast, so the word "lands" rather than fading in uniformly.
    final settled = (progress * progress * target.length).floor();
    final buffer = StringBuffer();

    for (var i = 0; i < target.length; i++) {
      final char = target[i];
      if (i < settled || char == ' ' || char == '\n') {
        buffer.write(char);
      } else {
        buffer.write(_glyphs[_random.nextInt(_glyphs.length)]);
      }
    }
    setState(() => _rendered = progress >= 1 ? target : buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _rendered,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.maxLines == null ? null : TextOverflow.ellipsis,
      // Screen readers should hear the word, never the noise.
      semanticsLabel: widget.text,
    );
  }
}
