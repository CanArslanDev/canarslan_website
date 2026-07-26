import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

/// A two-or-three state switch written as mono labels: `EN / TR`.
///
/// Deliberately not a pill. The nav bar's accent budget is already spent on
/// the filled action and the active link's underline, and a third chromatic
/// mark there would break the rationing rule — so this switch speaks the
/// nav link's language instead, lit foreground against dim, and reads as part
/// of the bar rather than as a control bolted onto it.
///
/// It carries no fixed width: the labels are two or three characters and the
/// row shrink-wraps them, which is what lets it survive beside a wordmark and
/// a call to action on a phone.
class SignalLabelSwitch extends StatelessWidget {
  const SignalLabelSwitch({
    required this.labels,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0)
            Padding(
              // Tight: the switch shares a phone's nav bar with a wordmark and
              // a call to action, and every point here comes off one of them.
              padding: const EdgeInsets.symmetric(horizontal: SignalSpace.x1),
              child: Text('/', style: SignalType.eyebrow(palette.dim)),
            ),
          _SwitchLabel(
            label: labels[i],
            active: i == selected,
            onTap: () => onSelected(i),
          ),
        ],
      ],
    );
  }
}

class _SwitchLabel extends StatefulWidget {
  const _SwitchLabel({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_SwitchLabel> createState() => _SwitchLabelState();
}

class _SwitchLabelState extends State<_SwitchLabel> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final tone = widget.active
        ? palette.fg
        : (_hovered ? palette.muted : palette.dim);

    return Semantics(
      button: true,
      selected: widget.active,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Text(
            widget.label.toUpperCase(),
            style: SignalType.eyebrow(tone),
          ),
        ),
      ),
    );
  }
}
