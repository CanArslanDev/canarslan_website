import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_colors.dart';
import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// The three behaviours of the ASCII atmosphere. All three are the same
/// character ramp on a monospace grid — only the field function differs.
enum SignalFieldMode {
  /// Polar interference: arms sweeping around a centre. The hero.
  vortex,

  /// A horizontal travelling wave. Used once, in accent, behind the work list.
  wave,

  /// Sparse lines drifting upward. Quiet sections and the footer.
  scan,
}

/// Animated ASCII texture, drawn behind content.
///
/// Rendering uses a pre-baked glyph atlas and a single [Canvas.drawAtlas] call
/// per frame — laying out a `TextPainter` for every one of the ~2000 cells
/// would cost far more than the effect is worth. The field advances at ~11fps
/// on purpose: it reads as a terminal refreshing rather than a smooth shader.
class SignalAsciiField extends StatefulWidget {
  const SignalAsciiField({
    required this.mode,
    super.key,
    this.opacity = 0.5,
    this.tintAccent = false,
  });

  final SignalFieldMode mode;

  /// Overall strength of the layer.
  final double opacity;

  /// When true the whole field is drawn in the accent colour instead of the
  /// resting [SignalPalette.dim] tone. Reserved for a single section.
  final bool tintAccent;

  @override
  State<SignalAsciiField> createState() => _SignalAsciiFieldState();
}

class _SignalAsciiFieldState extends State<SignalAsciiField>
    with SingleTickerProviderStateMixin {
  static const String _ramp = ' .·:-=+*o#%@';
  static const double _cellW = 9;
  static const double _cellH = 14;
  static const double _atlasScale = 2;

  Ticker? _ticker;
  Duration _lastFrame = Duration.zero;
  double _t = 0;
  ui.Image? _atlas;

  @override
  void initState() {
    super.initState();
    _t = math.Random().nextDouble() * 40;
    WidgetsBinding.instance.addPostFrameCallback((_) => _buildAtlas());
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _atlas?.dispose();
    super.dispose();
  }

  /// Bakes the ramp into one strip of white glyphs. White is required so the
  /// per-sprite colours in [Canvas.drawAtlas] can modulate them.
  Future<void> _buildAtlas() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final glyphs = _ramp.split('');

    for (var i = 0; i < glyphs.length; i++) {
      TextPainter(
        text: TextSpan(
          text: glyphs[i],
          style: const TextStyle(
            fontFamily: SignalFonts.mono,
            fontSize: 12 * _atlasScale,
            height: 1,
            // design-rules: allow — atlas glyphs must be pure white so the
            // per-sprite colours in drawAtlas can modulate them.
            color: Color(0xFFFFFFFF),
          ),
        ),
        textDirection: TextDirection.ltr,
      )
        ..layout()
        ..paint(canvas, Offset(i * _cellW * _atlasScale, 0))
        ..dispose();
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (glyphs.length * _cellW * _atlasScale).ceil(),
      (_cellH * _atlasScale).ceil(),
    );
    picture.dispose();

    if (!mounted) {
      image.dispose();
      return;
    }
    setState(() {
      _atlas?.dispose();
      _atlas = image;
    });
  }

  void _ensureTicker({required bool animate}) {
    if (!animate) {
      _ticker?.dispose();
      _ticker = null;
      return;
    }
    if (_ticker != null) return;
    _ticker = createTicker((elapsed) {
      if (elapsed - _lastFrame < SignalMotion.fieldFrame) return;
      _lastFrame = elapsed;
      setState(() => _t += SignalMotion.fieldStep);
    })
      ..start();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final reduce = MediaQuery.disableAnimationsOf(context);
    _ensureTicker(animate: !reduce);

    final atlas = _atlas;
    if (atlas == null) return const SizedBox.expand();

    return Opacity(
      opacity: widget.opacity,
      child: RepaintBoundary(
        child: CustomPaint(
          isComplex: true,
          painter: _AsciiFieldPainter(
            atlas: atlas,
            glyphCount: _ramp.length,
            mode: widget.mode,
            time: _t,
            base: widget.tintAccent ? palette.accent : palette.dim,
            hot: palette.accent,
            tintAccent: widget.tintAccent,
          ),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _AsciiFieldPainter extends CustomPainter {
  _AsciiFieldPainter({
    required this.atlas,
    required this.glyphCount,
    required this.mode,
    required this.time,
    required this.base,
    required this.hot,
    required this.tintAccent,
  });

  static const double _cellW = 9;
  static const double _cellH = 14;
  static const double _atlasScale = 2;

  final ui.Image atlas;
  final int glyphCount;
  final SignalFieldMode mode;
  final double time;
  final Color base;
  final Color hot;
  final bool tintAccent;

  double _value(int x, int y, int cols, int rows) {
    switch (mode) {
      case SignalFieldMode.vortex:
        // Polar interference — the field turns around a centre point.
        final cx = cols * 0.5;
        final cy = rows * 0.62;
        final dx = (x - cx) * 0.9;
        final dy = (y - cy) * 1.9;
        final rad = math.sqrt(dx * dx + dy * dy);
        final ang = math.atan2(dy, dx);
        return math.sin(rad * 0.17 - time * 0.75) +
            math.sin(ang * 5 + time * 0.62) +
            math.sin(rad * 0.05 + ang * 3 - time * 0.34) +
            math.sin(x * 0.06 + y * 0.09 + time * 0.2);
      case SignalFieldMode.wave:
        return math.sin(x * 0.14 - time * 1.05) +
            math.sin(y * 0.30 + time * 0.42) +
            math.sin((x * 0.5 + y) * 0.10 - time * 0.6) +
            0.6;
      case SignalFieldMode.scan:
        return math.sin(y * 0.55 + time * 1.5) * 1.7 +
            math.sin(x * 0.05 - time * 0.25) -
            0.9;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final cols = (size.width / _cellW).ceil();
    final rows = (size.height / _cellH).ceil();

    final transforms = <RSTransform>[];
    final rects = <Rect>[];
    final colors = <Color>[];

    for (var y = 0; y < rows; y++) {
      // The vortex and scan fields dissolve as they fall; the wave holds.
      final fade =
          mode == SignalFieldMode.wave ? 1.0 : 1 - (y / rows) * 0.72;
      for (var x = 0; x < cols; x++) {
        final n = (_value(x, y, cols, rows) + 4) / 8;
        if (n <= 0) continue;
        var index = (n * n * glyphCount * fade).floor();
        if (index <= 0) continue;
        if (index >= glyphCount) index = glyphCount - 1;

        final isHot = n > 0.9;
        final alpha = tintAccent
            ? (isHot ? 0.85 : 0.34) * fade
            : (isHot ? 0.6 : 0.3) * fade;

        transforms.add(
          RSTransform.fromComponents(
            rotation: 0,
            scale: 1 / _atlasScale,
            anchorX: 0,
            anchorY: 0,
            translateX: x * _cellW,
            translateY: y * _cellH,
          ),
        );
        rects.add(
          Rect.fromLTWH(
            index * _cellW * _atlasScale,
            0,
            _cellW * _atlasScale,
            _cellH * _atlasScale,
          ),
        );
        colors.add(
          (tintAccent || !isHot ? base : hot).withValues(alpha: alpha),
        );
      }
    }

    if (transforms.isEmpty) return;
    canvas.drawAtlas(
      atlas,
      transforms,
      rects,
      colors,
      BlendMode.modulate,
      null,
      Paint(),
    );
  }

  @override
  bool shouldRepaint(_AsciiFieldPainter old) =>
      old.time != time ||
      old.base != base ||
      old.hot != hot ||
      old.mode != mode ||
      old.atlas != atlas;
}
