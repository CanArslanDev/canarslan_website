import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_colors.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/material.dart';

/// Builds the app [ThemeData] for a SIGNAL palette.
abstract class SignalTheme {
  static ThemeData of(SignalPalette palette) {
    final base = palette.isDark ? Brightness.dark : Brightness.light;

    return ThemeData(
      useMaterial3: true,
      brightness: base,
      scaffoldBackgroundColor: palette.canvas,
      canvasColor: palette.canvas,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.accent,
        brightness: base,
      ).copyWith(
        surface: palette.canvas,
        primary: palette.accent,
        onPrimary: palette.accentInk,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: palette.accent.withValues(alpha: 0.35),
        cursorColor: palette.accent,
        selectionHandleColor: palette.accent,
      ),
      dividerTheme: DividerThemeData(
        color: palette.line,
        thickness: 1,
        space: 1,
      ),
      textTheme: _textTheme(palette),
      extensions: [SignalTokens(palette: palette)],
    );
  }

  /// The default dark world.
  static ThemeData get instrument => of(SignalPalette.instrument);

  /// The paper world, used by the inversion band.
  static ThemeData get paper => of(SignalPalette.paper);

  static TextTheme _textTheme(SignalPalette palette) {
    final body = SignalType.body(palette.fg);
    final small = SignalType.bodySmall(palette.muted);
    return TextTheme(
      bodyLarge: SignalType.lede(palette.fg),
      bodyMedium: body,
      bodySmall: small,
      labelLarge: SignalType.label(palette.fg),
      labelMedium: SignalType.labelSmall(palette.fg),
      labelSmall: SignalType.caption(palette.muted),
    );
  }
}
