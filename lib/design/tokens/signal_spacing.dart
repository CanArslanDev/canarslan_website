import 'package:flutter/painting.dart';

/// The 4px spacing ladder. Every gap and pad in the system is one of these.
abstract class SignalSpace {
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x12 = 48;
  static const double x16 = 64;
  static const double x20 = 80;
  static const double x30 = 120;
  static const double x40 = 160;

  /// Content column width. Sections run full-bleed; their contents do not.
  static const double column = 1280;

  /// The widest a paragraph is allowed to run, in logical pixels.
  ///
  /// Roughly 65 characters at the `lede` size, which is where a line stops
  /// being comfortable to track back from. Every block of prose on the site
  /// takes this, so they all break at the same place.
  static const double measure = 560;
}

/// Corner radius has exactly two legal values.
///
/// Structural things (cells, tables, inputs, images) are square. Interactive
/// things (buttons, tags, tabs) are full pills. Anything in between is outside
/// the system — that rule is what keeps it from drifting into generic
/// `rounded-lg` territory.
abstract class SignalRadius {
  /// Cells, cards, inputs, images, tables.
  static const BorderRadius structural = BorderRadius.zero;

  /// Buttons, chips, tabs, the nav CTA.
  static const BorderRadius interactive =
      BorderRadius.all(Radius.circular(999));
}

/// Hairline weights. Structure comes from these, never from shadows.
abstract class SignalStroke {
  /// Everywhere on the dark canvas.
  static const double hairline = 1;

  /// The museum cells in the paper band — heavier so the grid reads as a
  /// contact sheet rather than a table.
  static const double cell = 2;
}
