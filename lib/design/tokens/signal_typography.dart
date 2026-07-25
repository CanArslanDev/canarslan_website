import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:flutter/painting.dart';

/// The three SIGNAL faces, bundled as assets (see `pubspec.yaml`).
abstract class SignalFonts {
  /// Clash Display — geometric, flat-cut terminals. Lives at two extremes
  /// only: 200 for hairline display, 700 for mass. 600 carries mid-scale
  /// headings such as project names.
  static const String display = 'ClashDisplay';

  /// General Sans — everything readable.
  static const String body = 'GeneralSans';

  /// JetBrains Mono — eyebrows, section stamps, data columns, ASCII fields.
  static const String mono = 'JetBrainsMono';
}

/// Letter-spacing in Flutter is in logical pixels, not `em`. The system is
/// specified in `em`, so every tracked style multiplies through this.
double _track(double fontSize, double em) => fontSize * em;

/// The SIGNAL type scale.
///
/// Sizes that scale with the viewport take a `width`; the rest are fixed.
/// Nothing here reads a viewport percentage — that was the old system's
/// failure mode.
abstract class SignalType {
  // ── Mono: the technical voice ───────────────────────────────────────────

  /// 11px uppercase, +0.2em. Section eyebrows and micro-labels.
  static TextStyle eyebrow(Color color) => TextStyle(
        fontFamily: SignalFonts.mono,
        fontSize: 11,
        height: 1.4,
        letterSpacing: _track(11, 0.2),
        color: color,
      );

  /// 12px uppercase, +0.14em. Data columns, captions, meta.
  static TextStyle caption(Color color) => TextStyle(
        fontFamily: SignalFonts.mono,
        fontSize: 12,
        height: 1.4,
        letterSpacing: _track(12, 0.14),
        color: color,
      );

  /// 10px uppercase, +0.14em. Provenance notes and footnotes.
  static TextStyle micro(Color color) => TextStyle(
        fontFamily: SignalFonts.mono,
        fontSize: 10,
        height: 1.4,
        letterSpacing: _track(10, 0.14),
        color: color,
      );

  /// The only H2 device in the system: a mono stamp, uppercase, +0.2em.
  /// The tracking *is* the heading style.
  static TextStyle stamp(double width, Color color) {
    final size = fluid(width, min: 19, max: 42);
    return TextStyle(
      fontFamily: SignalFonts.mono,
      fontSize: size,
      height: 0.95,
      letterSpacing: _track(size, 0.2),
      color: color,
    );
  }

  // ── Display: Clash, at its two extremes ─────────────────────────────────

  /// Hero mass — Clash 700.
  static TextStyle displayMass(double width, Color color) {
    final size = fluid(width, min: 58, max: 168);
    return TextStyle(
      fontFamily: SignalFonts.display,
      fontWeight: FontWeight.w700,
      fontSize: size,
      height: 0.86,
      letterSpacing: _track(size, -0.035),
      color: color,
    );
  }

  /// Hero hairline — Clash 200. Same size as [displayMass]; the weight is
  /// the entire contrast.
  static TextStyle displayHair(double width, Color color) {
    final size = fluid(width, min: 58, max: 168);
    return TextStyle(
      fontFamily: SignalFonts.display,
      fontWeight: FontWeight.w200,
      fontSize: size,
      height: 0.92,
      letterSpacing: _track(size, -0.015),
      color: color,
    );
  }

  /// Section-scale Clash 700 — specimen headings.
  static TextStyle headingMass(double width, Color color) {
    final size = fluid(width, min: 38, max: 74);
    return TextStyle(
      fontFamily: SignalFonts.display,
      fontWeight: FontWeight.w700,
      fontSize: size,
      height: 0.9,
      letterSpacing: _track(size, -0.035),
      color: color,
    );
  }

  /// Section-scale Clash 200.
  static TextStyle headingHair(double width, Color color) {
    final size = fluid(width, min: 38, max: 74);
    return TextStyle(
      fontFamily: SignalFonts.display,
      fontWeight: FontWeight.w200,
      fontSize: size,
      height: 0.95,
      letterSpacing: _track(size, -0.015),
      color: color,
    );
  }

  /// Project and package names in the work list — Clash 600.
  static TextStyle rowName(double width, Color color) {
    final size = fluid(width, min: 24, max: 38);
    return TextStyle(
      fontFamily: SignalFonts.display,
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1,
      letterSpacing: _track(size, -0.03),
      color: color,
    );
  }

  // ── Body: General Sans ──────────────────────────────────────────────────

  static TextStyle body(Color color) => TextStyle(
        fontFamily: SignalFonts.body,
        fontSize: 16,
        height: 1.55,
        color: color,
      );

  static TextStyle bodySmall(Color color) => TextStyle(
        fontFamily: SignalFonts.body,
        fontSize: 14,
        height: 1.5,
        color: color,
      );

  /// Lede paragraphs under a section stamp.
  static TextStyle lede(Color color) => TextStyle(
        fontFamily: SignalFonts.body,
        fontSize: 17,
        height: 1.5,
        letterSpacing: _track(17, -0.01),
        color: color,
      );

  /// Interface labels — buttons, tabs, nav.
  static TextStyle label(Color color) => TextStyle(
        fontFamily: SignalFonts.body,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: _track(14, 0.03),
        color: color,
      );

  static TextStyle labelSmall(Color color) => TextStyle(
        fontFamily: SignalFonts.body,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.2,
        letterSpacing: _track(12, 0.03),
        color: color,
      );

  /// Cell titles in the paper band.
  static TextStyle cellTitle(Color color) => TextStyle(
        fontFamily: SignalFonts.body,
        fontSize: 17,
        fontWeight: FontWeight.w500,
        height: 1.25,
        color: color,
      );
}
