import 'package:canarslan_website/design/components/signal_reveal.dart';
import 'package:canarslan_website/design/components/signal_scramble_text.dart';
import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

/// Mono micro-label that sits above a heading. Always uppercase, always
/// tracked out to 0.2em — the label-maker voice.
class SignalEyebrow extends StatelessWidget {
  const SignalEyebrow(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: SignalType.eyebrow(color ?? context.signal.muted),
    );
  }
}

/// The system's only H2 device: an uppercase mono stamp whose letter-spacing
/// does the work a bold display face would normally do.
///
/// Scrambles into place the first time it scrolls into view.
class SignalStamp extends StatefulWidget {
  const SignalStamp(this.text, {super.key, this.color, this.animate = true});

  final String text;
  final Color? color;
  final bool animate;

  @override
  State<SignalStamp> createState() => _SignalStampState();
}

class _SignalStampState extends State<SignalStamp> {
  bool _play = false;

  @override
  Widget build(BuildContext context) {
    final style = SignalType.stamp(
      context.screenWidth,
      widget.color ?? context.signal.fg,
    );
    final label = widget.text.toUpperCase();

    if (!widget.animate) return Text(label, style: style);

    return SignalOnVisible(
      onVisible: () {
        if (mounted && !_play) setState(() => _play = true);
      },
      child: SignalScrambleText(label, style: style, play: _play),
    );
  }
}

/// Lead paragraph under a stamp. Capped at a readable measure.
class SignalLede extends StatelessWidget {
  const SignalLede(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 560),
      child: Text(
        text,
        style: SignalType.lede(color ?? context.signal.muted),
      ),
    );
  }
}

/// The smallest voice — provenance notes, asset credits, disclaimers.
class SignalMicro extends StatelessWidget {
  const SignalMicro(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: SignalType.micro(color ?? context.signal.dim),
    );
  }
}

/// Weight of a display line. The system allows only these two — the tension
/// between them is the signature, so there is no "medium" option.
enum SignalDisplayWeight {
  /// Clash 700.
  mass,

  /// Clash 200.
  hair,
}

/// A single line of display type.
class SignalDisplayLine extends StatelessWidget {
  const SignalDisplayLine(
    this.text, {
    required this.weight,
    super.key,
    this.color,
    this.section = false,
  });

  final String text;
  final SignalDisplayWeight weight;
  final Color? color;

  /// Section scale (38–74px) rather than hero scale (58–168px).
  final bool section;

  @override
  Widget build(BuildContext context) {
    final width = context.screenWidth;
    final tone = color ?? context.signal.fg;
    final style = switch ((weight, section)) {
      (SignalDisplayWeight.mass, false) => SignalType.displayMass(width, tone),
      (SignalDisplayWeight.hair, false) => SignalType.displayHair(width, tone),
      (SignalDisplayWeight.mass, true) => SignalType.headingMass(width, tone),
      (SignalDisplayWeight.hair, true) => SignalType.headingHair(width, tone),
    };
    return Text(text.toUpperCase(), style: style);
  }
}

/// An accent hairline that draws itself in from the left when revealed.
class SignalDrawnRule extends StatefulWidget {
  const SignalDrawnRule({super.key, this.color, this.thickness = 1});

  final Color? color;
  final double thickness;

  @override
  State<SignalDrawnRule> createState() => _SignalDrawnRuleState();
}

class _SignalDrawnRuleState extends State<SignalDrawnRule> {
  bool _drawn = false;

  @override
  Widget build(BuildContext context) {
    final reduce = MediaQuery.disableAnimationsOf(context);
    return SignalOnVisible(
      onVisible: () {
        if (mounted && !_drawn) setState(() => _drawn = true);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedContainer(
            duration: reduce ? Duration.zero : SignalMotion.scene,
            curve: SignalMotion.ease,
            alignment: Alignment.centerLeft,
            height: widget.thickness,
            width: (_drawn || reduce) ? constraints.maxWidth : 0,
            color: widget.color ?? context.signal.accent,
          );
        },
      ),
    );
  }
}
