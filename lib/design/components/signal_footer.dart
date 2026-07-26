import 'dart:async';

import 'package:canarslan_website/design/components/signal_ascii_field.dart';
import 'package:canarslan_website/design/components/signal_surfaces.dart';
import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

/// The closing gesture: a quiet band stamped with where you are and what time
/// it is there. The old site already showed a live clock — this turns it into
/// the page's signature rather than a row in a card.
class SignalFooter extends StatefulWidget {
  const SignalFooter({
    required this.name,
    required this.role,
    required this.contactLines,
    required this.locationLabel,
    required this.utcOffsetHours,
    super.key,
    this.note,
  });

  final String name;
  final String role;
  final List<String> contactLines;
  final String locationLabel;
  final int utcOffsetHours;
  final String? note;

  @override
  State<SignalFooter> createState() => _SignalFooterState();
}

class _SignalFooterState extends State<SignalFooter> {
  Timer? _timer;
  late DateTime _now = _localised();

  DateTime _localised() =>
      DateTime.now().toUtc().add(Duration(hours: widget.utcOffsetHours));

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _now = _localised()),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _clock {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(_now.hour)}:${two(_now.minute)}:${two(_now.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final offset = widget.utcOffsetHours;
    final sign = offset >= 0 ? '+' : '-';
    final stamp = '${widget.locationLabel} // UTC$sign'
        '${offset.abs().toString().padLeft(2, '0')}:00 // $_clock';

    final left = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.name} // ${widget.role}'.toUpperCase(),
          style: SignalType.eyebrow(palette.muted),
        ),
        const SizedBox(height: SignalSpace.x2),
        for (final line in widget.contactLines)
          Text(line, style: SignalType.caption(palette.muted)),
      ],
    );

    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(stamp, style: SignalType.caption(palette.fg)),
        if (widget.note != null) ...[
          const SizedBox(height: SignalSpace.x2),
          Text(
            widget.note!.toUpperCase(),
            style: SignalType.micro(palette.dim),
          ),
        ],
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(color: palette.canvas),
      child: ClipRect(
        child: Stack(
          children: [
            const Positioned.fill(
              child: IgnorePointer(
                child: SignalAsciiField(mode: SignalFieldMode.scan),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: SignalSpace.x12),
              child: SignalColumn(
                ruled: false,
                child: context.breakpoint.isCompact
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          left,
                          const SizedBox(height: SignalSpace.x6),
                          right,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: left),
                          right,
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
