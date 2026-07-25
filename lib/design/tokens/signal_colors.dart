import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// A complete SIGNAL colour set.
///
/// The system ships two palettes — [instrument] (the default dark canvas) and
/// [paper] (the museum inversion band). Every surface, line and text colour in
/// the app resolves through one of them; no widget declares a raw [Color].
@immutable
class SignalPalette {
  const SignalPalette({
    required this.canvas,
    required this.surface,
    required this.recess,
    required this.line,
    required this.lineHi,
    required this.fg,
    required this.muted,
    required this.dim,
    required this.accent,
    required this.accentText,
    required this.accentInk,
    required this.isDark,
  });

  factory SignalPalette.lerp(SignalPalette a, SignalPalette b, double t) {
    return SignalPalette(
      canvas: Color.lerp(a.canvas, b.canvas, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      recess: Color.lerp(a.recess, b.recess, t)!,
      line: Color.lerp(a.line, b.line, t)!,
      lineHi: Color.lerp(a.lineHi, b.lineHi, t)!,
      fg: Color.lerp(a.fg, b.fg, t)!,
      muted: Color.lerp(a.muted, b.muted, t)!,
      dim: Color.lerp(a.dim, b.dim, t)!,
      accent: Color.lerp(a.accent, b.accent, t)!,
      accentText: Color.lerp(a.accentText, b.accentText, t)!,
      accentInk: Color.lerp(a.accentInk, b.accentInk, t)!,
      isDark: t < 0.5 ? a.isDark : b.isDark,
    );
  }

  /// Page ground.
  final Color canvas;

  /// Cells, cards, the frosted nav — one step off the canvas.
  final Color surface;

  /// Input wells and row hover.
  final Color recess;

  /// The hairline that carries all structure.
  final Color line;

  /// Emphasised hairline — outlines and dividers that need to read first.
  final Color lineHi;

  /// Primary text.
  final Color fg;

  /// Secondary text, eyebrows, data columns.
  final Color muted;

  /// Lowest-priority text and the resting tone of the ASCII fields.
  final Color dim;

  /// The single chromatic voice. Fills and active states only.
  final Color accent;

  /// [accent] darkened where it must carry text — on paper the raw accent
  /// only reaches 1.3:1 against white, so it is never used as a text colour
  /// there.
  final Color accentText;

  /// Text drawn on top of an [accent] fill.
  final Color accentInk;

  final bool isDark;

  /// Fully transparent. Named so components never spell out a raw colour.
  static const transparent = Color(0x00000000);

  /// Dark canvas — the default world.
  static const instrument = SignalPalette(
    canvas: Color(0xFF050605),
    surface: Color(0xFF0C0D0B),
    recess: Color(0xFF131511),
    line: Color(0x29E9F0E0),
    lineHi: Color(0x6BE9F0E0),
    fg: Color(0xFFECEFE6),
    muted: Color(0xFF8A8F80),
    dim: Color(0xFF5C6154),
    accent: Color(0xFFC6F24E),
    accentText: Color(0xFFC6F24E),
    accentInk: Color(0xFF0A0C06),
    isDark: true,
  );

  /// Paper — used for the single inverted "museum" band.
  static const paper = SignalPalette(
    canvas: Color(0xFFF2F2EC),
    surface: Color(0xFFFBFBF6),
    recess: Color(0xFFE7E7DF),
    line: Color(0x330D0F0B),
    lineHi: Color(0x8C0D0F0B),
    fg: Color(0xFF0D0F0B),
    muted: Color(0xFF5B6055),
    dim: Color(0xFF8C9084),
    accent: Color(0xFFC6F24E),
    accentText: Color(0xFF5A7510),
    accentInk: Color(0xFF0A0C06),
    isDark: false,
  );

  /// The palette that reads as "the other side" of this one — what the
  /// inversion band switches to.
  SignalPalette get inverse => isDark ? paper : instrument;

  SignalPalette copyWith({
    Color? canvas,
    Color? surface,
    Color? recess,
    Color? line,
    Color? lineHi,
    Color? fg,
    Color? muted,
    Color? dim,
    Color? accent,
    Color? accentText,
    Color? accentInk,
    bool? isDark,
  }) {
    return SignalPalette(
      canvas: canvas ?? this.canvas,
      surface: surface ?? this.surface,
      recess: recess ?? this.recess,
      line: line ?? this.line,
      lineHi: lineHi ?? this.lineHi,
      fg: fg ?? this.fg,
      muted: muted ?? this.muted,
      dim: dim ?? this.dim,
      accent: accent ?? this.accent,
      accentText: accentText ?? this.accentText,
      accentInk: accentInk ?? this.accentInk,
      isDark: isDark ?? this.isDark,
    );
  }

}
