import 'package:flutter/animation.dart';

/// Three durations and one curve family. Anything that moves picks from here.
abstract class SignalMotion {
  /// Hover, focus, colour swaps.
  static const Duration state = Duration(milliseconds: 120);

  /// Enter / exit, reveals, row slides.
  static const Duration enter = Duration(milliseconds: 320);

  /// Scene-level moves: drawn hairlines, marquee handoffs, counters.
  static const Duration scene = Duration(milliseconds: 900);

  /// Character scramble on a section stamp.
  static const Duration scramble = Duration(milliseconds: 620);

  /// Shorter scramble used for the hover glitch on data rows.
  static const Duration glitch = Duration(milliseconds: 240);

  /// The system curve — a hard decelerate, matching the CSS
  /// `cubic-bezier(.16, 1, .3, 1)` used in the approved prototype.
  static const Curve ease = Cubic(0.16, 1, 0.3, 1);

  /// For colour and opacity, where the cubic above reads as sluggish.
  static const Curve linearish = Curves.easeOut;

  /// ASCII fields advance at ~11fps on purpose: it reads as a terminal
  /// refreshing rather than a smooth shader, and costs almost nothing.
  static const Duration fieldFrame = Duration(milliseconds: 85);
  static const double fieldStep = 0.15;
}
