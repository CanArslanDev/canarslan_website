import 'package:canarslan_website/design/components/signal_nav.dart';
import 'package:canarslan_website/design/components/signal_surfaces.dart';
import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_breakpoints.dart';
import 'package:canarslan_website/design/tokens/signal_colors.dart';
import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/widgets.dart';

/// The routes, once the bar can no longer hold them.
///
/// Not a drawer sliding over the page: this system has no elevation, so a
/// panel that floated above the content would be the only thing on the site
/// casting a shadow. It takes the body's place instead, which is also the
/// honest description of what it is — the whole screen is the navigation
/// while it is open.
///
/// Each row names its destination and its path. The path is not decoration:
/// it is the address the row goes to, and stating it is the same instrument
/// voice as the coordinate footer and the spec strip.
class SignalNavPanel extends StatelessWidget {
  const SignalNavPanel({
    required this.items,
    required this.selectedIndex,
    super.key,
  });

  final List<SignalNavItem> items;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;

    return ColoredBox(
      color: palette.canvas,
      // Scrollable because a phone in landscape has barely more height than
      // the bar itself, and a menu you cannot reach the bottom of is worse
      // than the one that was missing.
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: SignalSpace.x8),
          child: SignalColumn(
            ruled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < items.length; i++)
                  _PanelRow(item: items[i], active: i == selectedIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PanelRow extends StatefulWidget {
  const _PanelRow({required this.item, required this.active});

  final SignalNavItem item;
  final bool active;

  @override
  State<_PanelRow> createState() => _PanelRowState();
}

class _PanelRowState extends State<_PanelRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final lit = widget.active || _hovered;

    return Semantics(
      button: true,
      selected: widget.active,
      label: widget.item.label,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.item.onTap,
          child: AnimatedContainer(
            duration: SignalMotion.state,
            curve: SignalMotion.linearish,
            padding: const EdgeInsets.symmetric(vertical: SignalSpace.x6),
            decoration: BoxDecoration(
              color: _hovered ? palette.recess : SignalPalette.transparent,
              border: Border(bottom: BorderSide(color: palette.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.label.toUpperCase(),
                    style: SignalType.stamp(
                      context.screenWidth,
                      lit ? palette.fg : palette.muted,
                    ).copyWith(fontSize: 22, letterSpacing: 22 * 0.2),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.item.meta != null)
                  Text(
                    widget.item.meta!,
                    // The one accent in the panel, on the row you are already
                    // on — the same "you are here" job the underline does in
                    // the bar.
                    style: SignalType.micro(
                      widget.active ? palette.accentText : palette.dim,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
