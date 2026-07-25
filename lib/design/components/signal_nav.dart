import 'dart:ui' as ui;

import 'package:canarslan_website/design/components/signal_buttons.dart';
import 'package:canarslan_website/design/components/signal_surfaces.dart';
import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:canarslan_website/design/tokens/signal_colors.dart';
import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

class SignalNavItem {
  const SignalNavItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;
}

/// Frosted top bar: blurred canvas, one hairline underneath, wordmark left,
/// mono links right, a single filled action at the end.
class SignalNavBar extends StatelessWidget {
  const SignalNavBar({
    required this.wordmark,
    required this.items,
    required this.selectedIndex,
    required this.actionLabel,
    required this.onAction,
    super.key,
  });

  final String wordmark;
  final List<SignalNavItem> items;
  final int selectedIndex;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    // Links only appear once there is genuinely room for them beside the
    // wordmark and the action. Between phone and desktop the bar carries the
    // wordmark and the CTA alone rather than crushing the links.
    final showLinks = context.breakpoint.isExpanded;

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.canvas.withValues(alpha: 0.74),
            border: Border(bottom: BorderSide(color: palette.line)),
          ),
          child: SizedBox(
            height: 64,
            child: SignalColumn(
              ruled: false,
              child: Row(
                children: [
                  Text(
                    wordmark.toUpperCase(),
                    style: SignalType.caption(palette.fg)
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  if (showLinks) ...[
                    for (var i = 0; i < items.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(right: SignalSpace.x6),
                        child: _NavLink(
                          item: items[i],
                          active: i == selectedIndex,
                        ),
                      ),
                  ],
                  SignalPillButton(
                    label: actionLabel,
                    onPressed: onAction,
                    variant: SignalButtonVariant.filled,
                    compact: true,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.item, required this.active});

  final SignalNavItem item;
  final bool active;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final lit = widget.active || _hovered;

    return Semantics(
      button: true,
      selected: widget.active,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.item.onTap,
          child: AnimatedContainer(
            duration: SignalMotion.state,
            curve: SignalMotion.linearish,
            padding: const EdgeInsets.only(bottom: 3),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: lit ? palette.accent : SignalPalette.transparent,
                ),
              ),
            ),
            child: Text(
              widget.item.label.toUpperCase(),
              style: SignalType.eyebrow(lit ? palette.fg : palette.muted),
            ),
          ),
        ),
      ),
    );
  }
}
