import 'package:canarslan_website/design/tokens/signal_colors.dart';
import 'package:flutter/material.dart';

/// Carries the active [SignalPalette] down the tree.
///
/// Widgets read `context.signal` rather than importing a palette directly, so
/// the inversion band can hand its children the paper palette without any
/// widget knowing it is inverted.
@immutable
class SignalTokens extends ThemeExtension<SignalTokens> {
  const SignalTokens({required this.palette});

  final SignalPalette palette;

  @override
  SignalTokens copyWith({SignalPalette? palette}) =>
      SignalTokens(palette: palette ?? this.palette);

  @override
  SignalTokens lerp(ThemeExtension<SignalTokens>? other, double t) {
    if (other is! SignalTokens) return this;
    return SignalTokens(
      palette: SignalPalette.lerp(palette, other.palette, t),
    );
  }
}

extension SignalTokensContext on BuildContext {
  /// The palette in force at this point in the tree.
  SignalPalette get signal =>
      Theme.of(this).extension<SignalTokens>()?.palette ??
      SignalPalette.instrument;
}
