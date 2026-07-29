import 'dart:math' as math;

import 'package:canarslan_website/design/components/signal_ascii_field.dart';
import 'package:canarslan_website/design/theme/signal_theme.dart';
import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:canarslan_website/design/tokens/signal_colors.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:flutter/material.dart';

/// Square, hairline-bordered container. The system's card — except it is not a
/// card: no radius, no shadow, no elevation. The 1px line does all the work.
class SignalCell extends StatelessWidget {
  const SignalCell({
    required this.child,
    super.key,
    this.padding = const EdgeInsets.all(SignalSpace.x6),
    this.filled = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: filled ? palette.surface : null,
        border: Border.all(color: palette.line),
        borderRadius: SignalRadius.structural,
      ),
      child: child,
    );
  }
}

/// The centred content column, optionally showing the layout grid.
///
/// The faint vertical rules are not decoration: they expose the column the
/// page is actually built on, which is what makes the layout read as a
/// technical drawing rather than a stack of boxes.
class SignalColumn extends StatelessWidget {
  const SignalColumn({
    required this.child,
    super.key,
    this.ruled = true,
  });

  final Widget child;
  final bool ruled;

  @override
  Widget build(BuildContext context) {
    final horizontal = context.breakpoint.isCompact
        ? SignalSpace.x6
        : SignalSpace.x12;

    return LayoutBuilder(
      builder: (context, constraints) {
        // The column takes a concrete width rather than shrink-wrapping. Left
        // to its own devices the content collapses to its widest child and
        // Center pulls the whole block inwards — the hero would drift to the
        // middle instead of starting at the column's left edge. Reading the
        // constraint (rather than `width: infinity`) keeps this safe even
        // where the incoming width is unbounded.
        final width = constraints.hasBoundedWidth
            ? math.min(constraints.maxWidth, SignalSpace.column)
            : SignalSpace.column;

        return Center(
          child: SizedBox(
            width: width,
            child: Stack(
              children: [
                if (ruled)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _ColumnRulesPainter(
                          color: context.signal.line,
                          divisions: context.breakpoint.isCompact ? 2 : 6,
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontal),
                  child: child,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ColumnRulesPainter extends CustomPainter {
  _ColumnRulesPainter({required this.color, required this.divisions});

  final Color color;
  final int divisions;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: color.a * 0.5)
      ..strokeWidth = 1;
    final step = size.width / divisions;
    for (var i = 0; i <= divisions; i++) {
      final x = (i * step).floorToDouble() + 0.5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_ColumnRulesPainter old) =>
      old.color != color || old.divisions != divisions;
}

/// A full-bleed horizontal band, closed by a hairline, optionally carrying an
/// ASCII field behind its content.
class SignalSection extends StatelessWidget {
  const SignalSection({
    required this.child,
    super.key,
    this.field,
    this.fieldTintAccent = false,
    this.ruled = true,
    this.dense = false,
  });

  final Widget child;

  /// Behaviour of the ASCII layer behind this band, if any. Its strength comes
  /// with the mode — a band does not get to pick one.
  final SignalFieldMode? field;
  final bool fieldTintAccent;
  final bool ruled;

  /// Halves the vertical rhythm — used for strips rather than full sections.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final vertical = dense
        ? SignalSpace.x8
        : context.breakpoint.pick(
            compact: SignalSpace.x20,
            expanded: SignalSpace.x30,
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: palette.line)),
      ),
      child: ClipRect(
        child: Stack(
          children: [
            if (field != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: SignalAsciiField(
                    mode: field!,
                    tintAccent: fieldTintAccent,
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: vertical),
              child: SignalColumn(ruled: ruled, child: child),
            ),
          ],
        ),
      ),
    );
  }
}

/// Swaps the palette for its subtree — the museum band.
///
/// Children keep reading `context.signal`; none of them know they have been
/// inverted, which is why a single widget can flip a whole section.
class SignalInversion extends StatelessWidget {
  const SignalInversion({required this.child, super.key, this.palette});

  final Widget child;

  /// Defaults to the opposite of the surrounding palette.
  final SignalPalette? palette;

  @override
  Widget build(BuildContext context) {
    final target = palette ?? context.signal.inverse;
    return Theme(
      data: SignalTheme.of(target),
      child: ColoredBox(
        color: target.canvas,
        child: DefaultTextStyle.merge(
          // design-rules: allow — recolours inherited text only; the size and
          // face still come from whichever SignalType role is in play.
          style: TextStyle(color: target.fg),
          child: child,
        ),
      ),
    );
  }
}

/// A contact-sheet grid: equal-width tiles bound by shared rules.
///
/// Column count is derived from the available width, so a tile never carries a
/// fixed width — that is what makes the grid survive a phone. Rows size to
/// their tallest tile rather than to an aspect ratio, because a ratio has to
/// guess how long the longest line of copy is, and at narrow widths that guess
/// clips.
///
/// The container draws top and left, tiles draw right and bottom, so shared
/// edges stay a single stroke instead of doubling up.
class SignalTileGrid extends StatelessWidget {
  const SignalTileGrid({
    required this.children,
    super.key,
    this.minTileWidth = 240,
    this.maxColumns = 4,
    this.columns,
    this.maxRows,
    this.strokeWidth = SignalStroke.hairline,
    this.strokeColor,
    this.tilePadding = EdgeInsets.zero,
  });

  final List<Widget> children;

  /// Tiles never render narrower than this; the column count falls instead.
  final double minTileWidth;

  final int maxColumns;

  /// Fixes the column count instead of deriving it from the width.
  ///
  /// For grids whose shape is part of what they are rather than a response to
  /// the space available — a keypad is three across on any screen, and one
  /// that reflowed to four on a wide window would stop being a keypad.
  final int? columns;

  /// Caps a preview at whole rows.
  ///
  /// The column count is only known once the width is, so a caller that trims
  /// its own list to a fixed number of tiles is guessing: four tiles across
  /// three columns leaves a dangling half-row, which reads as missing content
  /// rather than as a deliberate excerpt. Trimming here — after the columns are
  /// known — keeps the sheet rectangular at every width.
  final int? maxRows;

  final double strokeWidth;

  /// Defaults to the palette hairline.
  final Color? strokeColor;

  final EdgeInsetsGeometry tilePadding;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final side = BorderSide(
      color: strokeColor ?? palette.line,
      width: strokeWidth,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final fit = constraints.hasBoundedWidth
            ? (constraints.maxWidth / minTileWidth).floor()
            : maxColumns;
        final across = columns ?? fit.clamp(1, maxColumns);
        final rowCap = maxRows;
        final visible = rowCap == null
            ? children
            : children.take(across * rowCap).toList();

        Widget tile(Widget? child) => DecoratedBox(
              decoration: BoxDecoration(
                border: Border(right: side, bottom: side),
              ),
              child: Padding(
                padding: tilePadding,
                child: child ?? const SizedBox.shrink(),
              ),
            );

        final rows = <Widget>[];
        for (var start = 0; start < visible.length; start += across) {
          final end = math.min(start + across, visible.length);
          final slice = visible.sublist(start, end);
          rows.add(
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = 0; i < across; i++)
                    Expanded(child: tile(i < slice.length ? slice[i] : null)),
                ],
              ),
            ),
          );
        }

        return DecoratedBox(
          decoration: BoxDecoration(border: Border(top: side, left: side)),
          child: Column(children: rows),
        );
      },
    );
  }
}

/// The museum band's grid: the same contact sheet in 2px ink.
class SignalMuseumGrid extends StatelessWidget {
  const SignalMuseumGrid({
    required this.children,
    super.key,
    this.minTileWidth = 255,
  });

  final List<Widget> children;
  final double minTileWidth;

  @override
  Widget build(BuildContext context) {
    return SignalTileGrid(
      minTileWidth: minTileWidth,
      strokeWidth: SignalStroke.cell,
      strokeColor: context.signal.fg,
      tilePadding: const EdgeInsets.all(SignalSpace.x6),
      children: children,
    );
  }
}
