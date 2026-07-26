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
  const SignalNavItem({required this.label, required this.onTap, this.meta});

  final String label;
  final VoidCallback onTap;

  /// Shown beside the label in `SignalNavPanel` — the route's own path. A
  /// menu that names where each row goes is the instrument voice applied to
  /// navigation, and it is true information rather than decoration.
  final String? meta;
}

/// The menu that stands in for the nav links once they no longer fit.
///
/// Passing one is what makes the bar's action a menu toggle below `expanded`;
/// without it the bar keeps its call to action at every width, which is right
/// for a surface you do not navigate within.
class SignalNavMenu {
  const SignalNavMenu({
    required this.openLabel,
    required this.closeLabel,
    required this.isOpen,
    required this.onToggle,
  });

  final String openLabel;
  final String closeLabel;
  final bool isOpen;
  final VoidCallback onToggle;
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
    this.compactActionLabel,
    this.menu,
    this.trailing,
  });

  final String wordmark;
  final List<SignalNavItem> items;
  final int selectedIndex;
  final String actionLabel;
  final VoidCallback onAction;

  /// A shorter form of [actionLabel], used once the bar runs out of room.
  ///
  /// The full phrase and a language switch do not both fit beside the wordmark
  /// on a phone. Naming the destination rather than the invitation is the
  /// cheaper of the two things to give up.
  /// Used only when there is no [menu] to put in the action's place.
  final String? compactActionLabel;

  /// Replaces the action with a menu toggle below `expanded`.
  ///
  /// The links fold away there, and until this existed nothing took their
  /// place: on a phone and on a tablet the bar offered one destination and the
  /// other four routes could not be reached at all. Handing the pill over is
  /// what makes room — the call to action is itself one of the five rows in
  /// the panel, so nothing is lost but a tap.
  final SignalNavMenu? menu;

  /// Sits between the links and the action, at every width.
  ///
  /// The links fold away below `expanded`; whatever goes here does not, which
  /// is why the language switch lives in this slot rather than among them — a
  /// visitor on a phone still has to be able to change language.
  final Widget? trailing;

  /// Fixed, and exposed: a page that needs to know how much of the window is
  /// left below the bar has to be able to ask.
  static const double height = 64;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    // Links only appear once there is genuinely room for them beside the
    // wordmark and the action. Between phone and desktop the bar carries the
    // wordmark, the switch and the CTA alone rather than crushing the links.
    final showLinks = context.breakpoint.isExpanded;
    final compact = context.breakpoint.isCompact;
    // Wherever the links are gone, the action hands its place to the menu —
    // otherwise the bar would offer one destination and hide the rest.
    final asMenu = !showLinks && menu != null;

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.canvas.withValues(alpha: 0.74),
            border: Border(bottom: BorderSide(color: palette.line)),
          ),
          child: SizedBox(
            height: SignalNavBar.height,
            child: SignalColumn(
              ruled: false,
              child: Row(
                children: [
                  // Expanded rather than a Spacer beside a fixed label: the
                  // wordmark is the one thing in the bar that is identity
                  // rather than function, so it is the one that gives when a
                  // very narrow screen runs the row out of width. Everything
                  // to its right keeps its size, and the bar cannot overflow.
                  Expanded(
                    child: Text(
                      wordmark.toUpperCase(),
                      // One step down the mono scale on a phone. Chrome can
                      // afford the smallest role, and that is what buys the
                      // switch its place beside the action.
                      style: (compact
                              ? SignalType.micro(palette.fg)
                              : SignalType.caption(palette.fg))
                          .copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                  if (trailing != null) ...[
                    trailing!,
                    SizedBox(
                      width: compact ? SignalSpace.x4 : SignalSpace.x6,
                    ),
                  ],
                  if (asMenu)
                    SignalPillButton(
                      label: menu!.isOpen ? menu!.closeLabel : menu!.openLabel,
                      onPressed: menu!.onToggle,
                      variant: SignalButtonVariant.filled,
                      compact: true,
                    )
                  else
                    SignalPillButton(
                      label: compact
                          ? (compactActionLabel ?? actionLabel)
                          : actionLabel,
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
