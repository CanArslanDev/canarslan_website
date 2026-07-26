import 'dart:math' as math;

import 'package:canarslan_website/data/site_models.dart';
import 'package:canarslan_website/design/signal.dart';
import 'package:canarslan_website/i18n/site_copy.dart';
import 'package:canarslan_website/i18n/site_locale.dart';
import 'package:flutter/widgets.dart';

/// A year of commits as a contact sheet of days.
///
/// Square cells, no radius, hairline grid — the same language as the rest of
/// the site rather than GitHub's green. Intensity runs through the accent,
/// which is exactly the "live data" use the palette reserves it for.
class ContributionCalendar extends StatelessWidget {
  const ContributionCalendar({required this.year, super.key});

  final ContributionYear year;

  static const double _gap = 3;
  static const double _maxCell = 15;
  static const double _labelBand = 18;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    if (year.isEmpty) return const SizedBox.shrink();

    final weeks = _weeks(year.days);

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : 720.0;
        // Cells shrink to fit rather than the grid scrolling: a calendar you
        // have to drag sideways stops being a shape you can read at a glance.
        final cell = math.min(
          _maxCell,
          (available - (weeks.length - 1) * _gap) / weeks.length,
        );
        final width = weeks.length * cell + (weeks.length - 1) * _gap;
        final height = 7 * cell + 6 * _gap + _labelBand;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              height: height,
              child: CustomPaint(
                painter: _CalendarPainter(
                  weeks: weeks,
                  cell: cell,
                  gap: _gap,
                  labelBand: _labelBand,
                  months: CalendarCopy.months(context.locale),
                  empty: palette.recess,
                  line: palette.line,
                  accent: palette.accent,
                  label: palette.dim,
                ),
              ),
            ),
            const SizedBox(height: SignalSpace.x4),
            _Legend(total: year.total),
          ],
        );
      },
    );
  }

  /// Groups days into calendar weeks, padding the first one so every column is
  /// a real Sunday-to-Saturday week.
  static List<List<ContributionDay?>> _weeks(List<ContributionDay> days) {
    final weeks = <List<ContributionDay?>>[];
    var current = List<ContributionDay?>.filled(7, null);

    for (final day in days) {
      // DateTime.weekday is Mon..Sun as 1..7; the grid starts on Sunday.
      final row = day.date.weekday % 7;
      current[row] = day;
      if (row == 6) {
        weeks.add(current);
        current = List<ContributionDay?>.filled(7, null);
      }
    }
    if (current.any((day) => day != null)) weeks.add(current);
    return weeks;
  }
}

class _CalendarPainter extends CustomPainter {
  _CalendarPainter({
    required this.weeks,
    required this.cell,
    required this.gap,
    required this.labelBand,
    required this.months,
    required this.empty,
    required this.line,
    required this.accent,
    required this.label,
  });

  final List<List<ContributionDay?>> weeks;
  final double cell;
  final double gap;
  final double labelBand;
  final List<String> months;
  final Color empty;
  final Color line;
  final Color accent;
  final Color label;

  /// Level 0 is a recess, not a faint accent — an empty day should read as
  /// absence rather than as a very small amount of work.
  ///
  /// The steps are deliberately uneven. Most days sit at level 1, so a linear
  /// ramp filled the whole year with mid-accent and the calendar read as one
  /// solid block; holding the bottom down keeps the busy days legible as
  /// peaks.
  static const ramp = [0.0, 0.16, 0.36, 0.64, 1.0];

  Color _fill(int level) => level == 0
      ? empty
      : accent.withValues(alpha: ramp[level.clamp(1, 4)]);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final stroke = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    var lastMonth = -1;
    var lastLabelRight = double.negativeInfinity;

    for (var w = 0; w < weeks.length; w++) {
      final x = w * (cell + gap);

      for (var d = 0; d < 7; d++) {
        final day = weeks[w][d];
        final rect = Rect.fromLTWH(
          x,
          labelBand + d * (cell + gap),
          cell,
          cell,
        );

        if (day == null) continue;
        paint.color = _fill(day.level);
        canvas
          ..drawRect(rect, paint)
          // A hairline on every cell keeps the grid legible where a run of
          // empty days would otherwise dissolve into the canvas.
          ..drawRect(rect, stroke);
      }

      // Month label above the first week that falls in a new month.
      final first = weeks[w].firstWhere((d) => d != null, orElse: () => null);
      if (first != null && first.date.month != lastMonth) {
        lastMonth = first.date.month;
        final painter = TextPainter(
          text: TextSpan(
            text: months[first.date.month - 1],
            style: SignalType.micro(label),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        // The year opens mid-month, so the first partial week and the one
        // after it both start a "new" month and their labels collide.
        final clearOfPrevious = x > lastLabelRight + gap * 2;
        if (clearOfPrevious && x + painter.width <= size.width) {
          painter.paint(canvas, Offset(x, 0));
          lastLabelRight = x + painter.width;
        }
        painter.dispose();
      }
    }
  }

  @override
  bool shouldRepaint(_CalendarPainter old) =>
      old.weeks != weeks ||
      old.cell != cell ||
      old.accent != accent ||
      old.empty != empty ||
      old.months != months;
}

class _Legend extends StatelessWidget {
  const _Legend({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    Widget swatch(double alpha) => Container(
          width: 11,
          height: 11,
          margin: const EdgeInsets.only(left: 3),
          decoration: BoxDecoration(
            color: alpha == 0
                ? palette.recess
                : palette.accent.withValues(alpha: alpha),
            border: Border.all(color: palette.line),
          ),
        );

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: SignalSpace.x6,
      runSpacing: SignalSpace.x2,
      children: [
        Text(
          CalendarCopy.total(total).of(context).toUpperCase(),
          style: SignalType.eyebrow(palette.muted),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              CalendarCopy.less.of(context).toUpperCase(),
              style: SignalType.micro(palette.dim),
            ),
            for (final alpha in _CalendarPainter.ramp) swatch(alpha),
            const SizedBox(width: SignalSpace.x2),
            Text(
              CalendarCopy.more.of(context).toUpperCase(),
              style: SignalType.micro(palette.dim),
            ),
          ],
        ),
      ],
    );
  }
}
