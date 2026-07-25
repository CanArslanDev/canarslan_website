import 'package:canarslan_website/design/components/signal_scramble_text.dart';
import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

/// A project or package as a wireframe row rather than a card.
///
/// Hovering slides the row in, floods the recess colour behind it and glitches
/// the name — the interaction is the ASCII motif applied to a list.
class SignalDataRow extends StatefulWidget {
  const SignalDataRow({
    required this.name,
    required this.description,
    required this.meta,
    required this.onTap,
    super.key,
  });

  final String name;
  final String description;

  /// Right-hand data columns — language, source, stars.
  final List<String> meta;

  final VoidCallback onTap;

  @override
  State<SignalDataRow> createState() => _SignalDataRowState();
}

class _SignalDataRowState extends State<SignalDataRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final wide = !context.breakpoint.isCompact;
    final reduce = MediaQuery.disableAnimationsOf(context);

    final name = SignalScrambleText(
      widget.name,
      style: SignalType.rowName(
        context.screenWidth,
        _hovered ? palette.accentText : palette.fg,
      ),
      duration: SignalMotion.glitch,
      play: _hovered && !reduce,
    );

    final description = Text(
      widget.description,
      style: SignalType.bodySmall(palette.muted),
    );

    final columns = [
      for (final value in widget.meta)
        SizedBox(
          width: 96,
          child: Text(
            value.toUpperCase(),
            style: SignalType.eyebrow(palette.muted),
          ),
        ),
    ];

    return Semantics(
      button: true,
      label: '${widget.name}. ${widget.description}',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: SignalMotion.enter,
            curve: SignalMotion.ease,
            padding: EdgeInsets.only(
              top: SignalSpace.x6,
              bottom: SignalSpace.x6,
              left: _hovered ? SignalSpace.x4 : 0,
            ),
            decoration: BoxDecoration(
              color: _hovered ? palette.recess : null,
              border: Border(bottom: BorderSide(color: palette.line)),
            ),
            child: wide
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            name,
                            const SizedBox(height: SignalSpace.x1),
                            description,
                          ],
                        ),
                      ),
                      const SizedBox(width: SignalSpace.x6),
                      ...columns,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      name,
                      const SizedBox(height: SignalSpace.x1),
                      description,
                      const SizedBox(height: SignalSpace.x3),
                      Wrap(spacing: SignalSpace.x4, children: columns),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
