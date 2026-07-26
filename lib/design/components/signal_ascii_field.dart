import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:canarslan_website/design/theme/signal_tokens.dart';
import 'package:canarslan_website/design/tokens/signal_colors.dart';
import 'package:canarslan_website/design/tokens/signal_motion.dart';
import 'package:canarslan_website/design/tokens/signal_typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The four behaviours of the ASCII atmosphere. All four are the same character
/// ramp on a monospace grid — only the field function differs.
enum SignalFieldMode {
  /// Polar interference: arms sweeping around a centre. The hero.
  vortex,

  /// A horizontal travelling wave. Used once, in accent, behind the work list.
  wave,

  /// Sparse lines drifting upward. Quiet sections and the footer.
  scan,

  /// Concentric rings breathing out from the centre. Slower and more ordered
  /// than [vortex], which is why it suits the paper band: the museum should
  /// not feel like the cockpit.
  ripple,
}

const String _ramp = ' .·:-=+*o#%@';
const double _cellW = 9;
const double _cellH = 14;
const double _atlasScale = 2;

/// The glyph strip, baked once for the whole app.
///
/// Every field draws the same twelve characters at the same size, and a page
/// carries up to five of them — the hero, a section, the paper band and the
/// footer. Baking per instance meant five identical GPU textures and five
/// `toImage` round trips on load. The image is never disposed: it is a
/// process-lifetime constant, and there is no point in the site at which the
/// last field goes away.
Future<ui.Image>? _atlasFuture;

Future<ui.Image> _glyphAtlas() => _atlasFuture ??= _bakeAtlas();

/// Bakes the ramp into one strip of white glyphs. White is required so the
/// per-sprite colours in `drawRawAtlas` can modulate them.
Future<ui.Image> _bakeAtlas() async {
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
          // per-sprite colours in drawRawAtlas can modulate them.
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
  return image;
}

/// Animated ASCII texture, drawn behind content.
///
/// Rendering goes through a pre-baked glyph atlas and a single
/// [Canvas.drawRawAtlas] call per frame — laying out a `TextPainter` for every
/// one of the ~2000 cells would cost far more than the effect is worth. The
/// field advances at ~11fps on purpose: it reads as a terminal refreshing
/// rather than a smooth shader.
///
/// Three things keep that cheap enough to run five at a time:
///
/// * **A timer, not a ticker.** A `Ticker` asks the scheduler for a frame every
///   vsync, and at 85ms per step five of every six did nothing. The timer only
///   wakes the pipeline when the field actually moves.
/// * **No widget rebuild.** The clock is a `ValueNotifier` handed to the
///   painter as its `repaint`, so a step runs `paint` and nothing else — no
///   element visit, no layout.
/// * **No `Opacity`.** The layer's strength is multiplied into each glyph's
///   alpha instead, which is arithmetically the same thing on a grid whose
///   cells cannot overlap, and skips a full-screen `saveLayer` per field per
///   frame.
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

class _SignalAsciiFieldState extends State<SignalAsciiField> {
  /// The field's own clock. Starts at a random phase so two fields on the same
  /// page are never in step.
  final ValueNotifier<double> _time =
      ValueNotifier(math.Random().nextDouble() * 40);

  Timer? _timer;
  ui.Image? _atlas;

  @override
  void initState() {
    super.initState();
    _glyphAtlas().then((image) {
      if (mounted) setState(() => _atlas = image);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _time.dispose();
    super.dispose();
  }

  void _ensureRunning({required bool animate}) {
    if (!animate) {
      _timer?.cancel();
      _timer = null;
      return;
    }
    _timer ??= Timer.periodic(
      SignalMotion.fieldFrame,
      (_) => _time.value += SignalMotion.fieldStep,
    );
  }

  /// The colour the field rests at.
  ///
  /// On the dark canvas that is [SignalPalette.dim] — one step lighter than the
  /// ground. Paper needs the mirror of that, one step *darker*, and `dim` there
  /// is a light grey that sits almost on top of the ground: the same token
  /// produces a field you cannot see. Ink is the equivalent presence, held back
  /// by the section's own opacity.
  Color _restingTone(SignalPalette palette) =>
      palette.isDark ? palette.dim : palette.fg;

  @override
  Widget build(BuildContext context) {
    final palette = context.signal;
    final reduce = MediaQuery.disableAnimationsOf(context);
    _ensureRunning(animate: !reduce);

    final atlas = _atlas;
    if (atlas == null) return const SizedBox.expand();

    return RepaintBoundary(
      child: CustomPaint(
        isComplex: true,
        // The picture is different every step, so there is nothing here worth
        // the raster cache trying to hold on to.
        willChange: !reduce,
        painter: _AsciiFieldPainter(
          atlas: atlas,
          clock: _time,
          mode: widget.mode,
          opacity: widget.opacity,
          // accentText, not accent: on the paper palette the raw accent
          // reaches 1.3:1 against the ground and the field would vanish. On
          // the dark canvas the two are the same colour, so nothing changes
          // there.
          base: widget.tintAccent
              ? palette.accentText
              : _restingTone(palette),
          hot: palette.accentText,
          tintAccent: widget.tintAccent,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _AsciiFieldPainter extends CustomPainter {
  _AsciiFieldPainter({
    required this.atlas,
    required this.clock,
    required this.mode,
    required this.opacity,
    required this.base,
    required this.hot,
    required this.tintAccent,
  })  : _baseRgb = base.toARGB32() & 0x00FFFFFF,
        _hotRgb = hot.toARGB32() & 0x00FFFFFF,
        super(repaint: clock);

  final ui.Image atlas;

  /// Drives the repaint directly, so a step never rebuilds a widget.
  final ValueListenable<double> clock;

  final SignalFieldMode mode;
  final double opacity;
  final Color base;
  final Color hot;
  final bool tintAccent;

  final int _baseRgb;
  final int _hotRgb;

  /// Sprite buffers, reused between frames. Growable lists of `RSTransform`,
  /// `Rect` and `Color` meant three allocations and ~2000 pushes per field per
  /// step, all of it thrown away 85ms later.
  Float32List _transforms = Float32List(0);
  Float32List _rects = Float32List(0);
  Int32List _colors = Int32List(0);

  final Paint _paint = Paint();

  double _value(int x, int y, int cols, int rows, double time) {
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
      case SignalFieldMode.ripple:
        // Rings only — no angular term, which is what separates this from the
        // vortex: the pattern expands rather than turns.
        final cx = cols * 0.5;
        final cy = rows * 0.5;
        final dx = (x - cx) * 0.9;
        final dy = (y - cy) * 1.9;
        final rad = math.sqrt(dx * dx + dy * dy);
        return math.sin(rad * 0.26 - time * 0.8) +
            math.sin(rad * 0.1 - time * 0.35) +
            math.sin(x * 0.05 + time * 0.15) * 0.6 +
            0.3;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;
    final cols = (size.width / _cellW).ceil();
    final rows = (size.height / _cellH).ceil();
    final time = clock.value;
    const glyphCount = _ramp.length;

    final capacity = cols * rows;
    if (_colors.length < capacity) {
      _transforms = Float32List(capacity * 4);
      _rects = Float32List(capacity * 4);
      _colors = Int32List(capacity);
    }

    var count = 0;
    for (var y = 0; y < rows; y++) {
      // The vortex and scan fields dissolve as they fall. The wave and the
      // ripple hold: a downward fade would cut one side off a pattern that is
      // symmetrical about its centre.
      final holds = mode == SignalFieldMode.wave ||
          mode == SignalFieldMode.ripple;
      final fade = holds ? 1.0 : 1 - (y / rows) * 0.72;
      for (var x = 0; x < cols; x++) {
        final n = (_value(x, y, cols, rows, time) + 4) / 8;
        if (n <= 0) continue;
        var index = (n * n * glyphCount * fade).floor();
        if (index <= 0) continue;
        if (index >= glyphCount) index = glyphCount - 1;

        final isHot = n > 0.9;
        // The layer's strength lands here rather than on an Opacity widget.
        // The cells tile exactly and the atlas rects clip each glyph to its
        // own cell, so nothing overlaps and multiplying through is the same
        // composite without the offscreen buffer.
        final alpha = (tintAccent
                ? (isHot ? 0.85 : 0.34) * fade
                : (isHot ? 0.6 : 0.3) * fade) *
            opacity;

        final t = count * 4;
        _transforms[t] = 1 / _atlasScale;
        _transforms[t + 1] = 0;
        _transforms[t + 2] = x * _cellW;
        _transforms[t + 3] = y * _cellH;

        final left = index * _cellW * _atlasScale;
        _rects[t] = left;
        _rects[t + 1] = 0;
        _rects[t + 2] = left + _cellW * _atlasScale;
        _rects[t + 3] = _cellH * _atlasScale;

        final byte = (alpha * 255).round().clamp(0, 255);
        final rgb = tintAccent || !isHot ? _baseRgb : _hotRgb;
        _colors[count] = (byte << 24) | rgb;
        count++;
      }
    }

    if (count == 0) return;
    canvas.drawRawAtlas(
      atlas,
      Float32List.sublistView(_transforms, 0, count * 4),
      Float32List.sublistView(_rects, 0, count * 4),
      Int32List.sublistView(_colors, 0, count),
      BlendMode.modulate,
      null,
      _paint,
    );
  }

  @override
  bool shouldRepaint(_AsciiFieldPainter old) =>
      old.clock != clock ||
      old.base != base ||
      old.hot != hot ||
      old.mode != mode ||
      old.opacity != opacity ||
      old.atlas != atlas;
}
