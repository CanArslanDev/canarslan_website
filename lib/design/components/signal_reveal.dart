import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:canarslan_website/design/tokens/signal_spacing.dart';
import 'package:flutter/widgets.dart';

/// Fades and lifts its child in the first time it scrolls into view.
///
/// Uses the same 14px / 500ms / decelerate recipe everywhere, so blocks across
/// the site enter with one rhythm rather than each section inventing its own.
class SignalReveal extends StatefulWidget {
  const SignalReveal({
    required this.child,
    super.key,
    this.delay = Duration.zero,
    this.offset = SignalSpace.x3 + 2,
  });

  final Widget child;
  final Duration delay;
  final double offset;

  @override
  State<SignalReveal> createState() => _SignalRevealState();
}

class _SignalRevealState extends State<SignalReveal> {
  bool _shown = false;

  void _show() {
    if (_shown || !mounted) return;
    if (widget.delay == Duration.zero) {
      setState(() => _shown = true);
      return;
    }
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _shown = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return SignalOnVisible(
      onVisible: _show,
      child: AnimatedSlide(
        offset: _shown ? Offset.zero : Offset(0, widget.offset / 100),
        duration: SignalMotion.enter,
        curve: SignalMotion.ease,
        child: AnimatedOpacity(
          opacity: _shown ? 1 : 0,
          duration: SignalMotion.enter,
          curve: SignalMotion.linearish,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Fires [onVisible] once the widget has any part inside the viewport.
///
/// Flutter has no IntersectionObserver, so this compares the render object's
/// global position against the viewport whenever the enclosing scroll offset
/// changes. It listens to the ancestor [ScrollPosition] directly rather than
/// to `ScrollNotification` — notifications bubble *up* from the scrollable,
/// and this widget lives *below* it, so a listener here would never be
/// called. It detaches as soon as it has fired.
class SignalOnVisible extends StatefulWidget {
  const SignalOnVisible({
    required this.onVisible,
    required this.child,
    super.key,
  });

  final VoidCallback onVisible;
  final Widget child;

  @override
  State<SignalOnVisible> createState() => SignalOnVisibleState();
}

class SignalOnVisibleState extends State<SignalOnVisible> {
  /// Re-checks after the first frame. Bundled fonts finish loading a beat
  /// after mount and reflow the page; without these a block that sat just
  /// below the fold on frame one would stay hidden until the visitor
  /// happened to scroll — which, on a tall viewport, may be never.
  static const _recheckDelays = [
    Duration(milliseconds: 120),
    Duration(milliseconds: 400),
    Duration(milliseconds: 1000),
  ];

  bool _fired = false;
  ScrollPosition? _position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    for (final delay in _recheckDelays) {
      Future<void>.delayed(delay, _check);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _detach();
    if (_fired) return;
    _position = Scrollable.maybeOf(context)?.position;
    _position?.addListener(_check);
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  void _detach() {
    _position?.removeListener(_check);
    _position = null;
  }

  void _check() {
    if (_fired || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final screenHeight = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    // Trigger slightly before the block is fully on screen so the movement
    // has finished by the time it is properly in view.
    if (top < screenHeight * 0.94 && top + box.size.height > 0) {
      _fired = true;
      _detach();
      widget.onVisible();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
