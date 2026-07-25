import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_colors.dart';
import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

/// The two button treatments. They are designed to appear as a pair — a filled
/// accent action beside a hairline-outlined companion.
enum SignalButtonVariant { filled, ghost }

/// Pill button. Interactive things are fully rounded; structural things are
/// square. There is no third radius in the system.
class SignalPillButton extends StatefulWidget {
  const SignalPillButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = SignalButtonVariant.ghost,
    this.trailing,
    this.compact = false,
  });

  final String label;
  final VoidCallback onPressed;
  final SignalButtonVariant variant;

  /// Rendered after the label in mono — used for the `->` affordance.
  final String? trailing;

  final bool compact;

  @override
  State<SignalPillButton> createState() => _SignalPillButtonState();
}

class _SignalPillButtonState extends State<SignalPillButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final filled = widget.variant == SignalButtonVariant.filled;

    final background = filled ? palette.accent : SignalPalette.transparent;
    final foreground = filled ? palette.accentInk : palette.fg;
    final border = filled
        ? palette.accent
        : (_hovered ? palette.fg : palette.lineHi);

    return Semantics(
      button: true,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: SignalMotion.state,
            curve: SignalMotion.linearish,
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? SignalSpace.x4 : 26,
              vertical: widget.compact ? 7 : SignalSpace.x3,
            ),
            decoration: BoxDecoration(
              color: background,
              borderRadius: SignalRadius.interactive,
              border: Border.all(color: border),
              // The only shadow in the system: the accent glow on a filled
              // action while hovered.
              boxShadow: filled && _hovered
                  ? [
                      BoxShadow(
                        color: palette.accent.withValues(alpha: 0.5),
                        blurRadius: 28,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label.toUpperCase(),
                  style: widget.compact
                      ? SignalType.labelSmall(foreground)
                      : SignalType.label(foreground),
                ),
                if (widget.trailing != null) ...[
                  const SizedBox(width: SignalSpace.x2),
                  Text(
                    widget.trailing!,
                    style: SignalType.caption(
                      foreground.withValues(alpha: 0.75),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Small pill label. Outlined by default; filled when it marks a live state.
class SignalChip extends StatelessWidget {
  const SignalChip(this.label, {super.key, this.active = false});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SignalSpace.x3 + 2,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: active ? palette.accent : null,
        borderRadius: SignalRadius.interactive,
        border: Border.all(color: active ? palette.accent : palette.lineHi),
      ),
      child: Text(
        label.toUpperCase(),
        style: SignalType.eyebrow(
          active ? palette.accentInk : palette.muted,
        ).copyWith(letterSpacing: 11 * 0.14),
      ),
    );
  }
}

/// Horizontal filter row. The selected pill fills with accent and carries the
/// system's only other glow.
class SignalTabs extends StatelessWidget {
  const SignalTabs({
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
    return Wrap(
      spacing: SignalSpace.x2,
      runSpacing: SignalSpace.x2,
      children: [
        for (var i = 0; i < labels.length; i++)
          _Tab(
            label: labels[i],
            active: i == selected,
            onTap: () => onSelected(i),
          ),
      ],
    );
  }
}

class _Tab extends StatefulWidget {
  const _Tab({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final active = widget.active;
    final foreground = active
        ? palette.accentInk
        : (_hovered ? palette.fg : palette.muted);

    return Semantics(
      button: true,
      selected: active,
      label: widget.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: SignalMotion.state,
            curve: SignalMotion.linearish,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: active ? palette.accent : null,
              borderRadius: SignalRadius.interactive,
              border: Border.all(
                color: active
                    ? palette.accent
                    : (_hovered ? palette.fg : palette.lineHi),
              ),
              boxShadow: active
                  ? [
                      BoxShadow(
                        color: palette.accent.withValues(alpha: 0.42),
                        blurRadius: 26,
                      ),
                    ]
                  : null,
            ),
            child: Text(
              widget.label,
              style: SignalType.label(foreground).copyWith(fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
