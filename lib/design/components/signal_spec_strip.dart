import 'dart:async';

import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

/// One cell of a [SignalSpecStrip].
@immutable
class SignalSpecEntry {
  const SignalSpecEntry({required this.label, this.value, this.child});

  /// The quiet half of the pair.
  final String label;

  /// The loud half. Rendered in foreground, before or after [label] depending
  /// on which reads better — pass it as part of [label] when order matters.
  final String? value;

  /// Replaces the text pair entirely, for a live cell.
  final Widget? child;
}

/// A wireframe row of facts under the hero: an instrument readout rather than
/// a row of chips.
///
/// Splits into equal columns only where there is room for them; below that the
/// cells stack full-width. A wrap leaves ragged half-rows whose hairlines stop
/// meeting, which reads worse than a plain stack.
class SignalSpecStrip extends StatelessWidget {
  const SignalSpecStrip({required this.entries, super.key});

  final List<SignalSpecEntry> entries;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final stacked = !context.breakpoint.isExpanded;

    Widget cell(SignalSpecEntry entry, {required bool last}) {
      final content = entry.child ??
          Text.rich(
            TextSpan(
              style: SignalType.eyebrow(palette.muted),
              children: [
                TextSpan(text: entry.label.toUpperCase()),
                if (entry.value != null)
                  TextSpan(
                    text: '  ${entry.value!.toUpperCase()}',
                    style: SignalType.eyebrow(palette.fg),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.clip,
          );

      return Container(
        width: stacked ? double.infinity : null,
        constraints: stacked ? null : const BoxConstraints(minWidth: 140),
        padding: const EdgeInsets.symmetric(
          horizontal: SignalSpace.x4,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          border: last
              ? null
              : Border(
                  right: stacked
                      ? BorderSide.none
                      : BorderSide(color: palette.line),
                  bottom: stacked
                      ? BorderSide(color: palette.line)
                      : BorderSide.none,
                ),
        ),
        child: content,
      );
    }

    final cells = [
      for (var i = 0; i < entries.length; i++)
        cell(entries[i], last: i == entries.length - 1),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: palette.line)),
      child: stacked
          ? Column(mainAxisSize: MainAxisSize.min, children: cells)
          : Row(
              children: [for (final c in cells) Expanded(child: c)],
            ),
    );
  }
}

/// Blinking accent LED beside the local time — the system's "live" marker, and
/// one of the three places the accent is allowed to appear on a page.
class SignalLiveClock extends StatefulWidget {
  const SignalLiveClock({
    required this.utcOffsetHours,
    super.key,
    this.label = 'Live',
  });

  final int utcOffsetHours;
  final String label;

  @override
  State<SignalLiveClock> createState() => _SignalLiveClockState();
}

class _SignalLiveClockState extends State<SignalLiveClock> {
  Timer? _timer;
  bool _lit = true;
  late DateTime _now = _localised();

  DateTime _localised() =>
      DateTime.now().toUtc().add(Duration(hours: widget.utcOffsetHours));

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 600), (tick) {
      if (!mounted) return;
      setState(() {
        _now = _localised();
        _lit = tick.tick % 4 != 0;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    String two(int v) => v.toString().padLeft(2, '0');
    final offset = widget.utcOffsetHours;
    final sign = offset >= 0 ? '+' : '-';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedOpacity(
          opacity: _lit ? 1 : 0.15,
          duration: const Duration(milliseconds: 120),
          child: Container(width: 7, height: 7, color: palette.accent),
        ),
        const SizedBox(width: SignalSpace.x2),
        Flexible(
          child: Text.rich(
            TextSpan(
              style: SignalType.eyebrow(palette.muted),
              children: [
                TextSpan(text: '${widget.label.toUpperCase()}  '),
                TextSpan(
                  text: '${two(_now.hour)}:${two(_now.minute)}',
                  style: SignalType.eyebrow(palette.fg),
                ),
                TextSpan(text: '  UTC$sign${offset.abs()}'),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.clip,
          ),
        ),
      ],
    );
  }
}
