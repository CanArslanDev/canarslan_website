import 'package:flutter/widgets.dart';

/// Width breakpoints, replacing the viewport-percentage sizing the old site
/// used. Layout decisions read the actual constraint, so resizing the window
/// works and ultra-wide screens do not blow the type up.
enum SignalBreakpoint {
  /// Phones.
  compact,

  /// Tablets and small laptops.
  medium,

  /// Desktop.
  expanded;

  static const double mediumMin = 760;
  static const double expandedMin = 1100;

  static SignalBreakpoint of(double width) {
    if (width >= expandedMin) return SignalBreakpoint.expanded;
    if (width >= mediumMin) return SignalBreakpoint.medium;
    return SignalBreakpoint.compact;
  }

  bool get isCompact => this == SignalBreakpoint.compact;
  bool get isExpanded => this == SignalBreakpoint.expanded;

  /// Pick a value per breakpoint without a chain of if-statements.
  T pick<T>({required T compact, required T expanded, T? medium}) {
    switch (this) {
      case SignalBreakpoint.compact:
        return compact;
      case SignalBreakpoint.medium:
        return medium ?? expanded;
      case SignalBreakpoint.expanded:
        return expanded;
    }
  }
}

extension SignalBreakpointContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  SignalBreakpoint get breakpoint => SignalBreakpoint.of(screenWidth);

  /// Whether the visitor asked the OS to reduce motion. Every animated
  /// component in the system honours this.
  bool get reduceMotion => MediaQuery.disableAnimationsOf(this);
}

/// The Dart equivalent of CSS `clamp()`: grows with the viewport between
/// [minWidth] and [maxWidth], then stops.
double fluid(
  double width, {
  required double min,
  required double max,
  double minWidth = 380,
  double maxWidth = 1440,
}) {
  if (width <= minWidth) return min;
  if (width >= maxWidth) return max;
  final t = (width - minWidth) / (maxWidth - minWidth);
  return min + (max - min) * t;
}
