import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

class VHSEffect extends StatefulWidget {
  const VHSEffect({required this.child, super.key});
  final Widget child;

  @override
  State<VHSEffect> createState() => _VHSEffectState();
}

class _VHSEffectState extends State<VHSEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late math.Random _random;
  bool _isGlitching = false;
  double _glitchOffset = 0;
  Timer? _glitchTimer;
  Timer? _glitchEffectTimer;

  @override
  void initState() {
    super.initState();
    _random = math.Random();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 16000),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    // Rastgele glitch efekti zamanlaması
    _startGlitchTimer();
  }

  void _startGlitchTimer() {
    _glitchTimer?.cancel();
    _glitchTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_random.nextDouble() < 0.75) {
        // %75 ihtimalle glitch
        _triggerGlitch();
      }
    });
  }

  void _triggerGlitch() {
    setState(() {
      _isGlitching = true;
      _glitchOffset = (_random.nextDouble() - 0.5) * 50;
    });

    _glitchEffectTimer?.cancel();
    _glitchEffectTimer =
        Timer(Duration(milliseconds: _random.nextInt(400) + 100), () {
      if (mounted) {
        setState(() {
          _isGlitching = false;
          _glitchOffset = 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _glitchTimer?.cancel();
    _glitchEffectTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          // CRT Eğriliği ve Ana İçerik
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0008)
              // Yatay bombe efekti
              ..setEntry(0, 0, 1.0 + 0.15 * math.sin(math.pi * 0.5))
              // Dikey bombe efekti - üst ve alttan daralma
              ..setEntry(1, 1, 1.0 - 0.2 * math.cos(math.pi * 0.5))
              // Perspektif için hafif rotasyon
              ..rotateX(0.1)
              // Kenarlardan içe doğru daha sert bükülme
              ..scale(
                0.85 - 0.2 * math.cos(math.pi * 0.5),
                0.8 + 0.2 * math.sin(math.pi * 0.5),
                1,
              ),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 1.5,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.1),
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    radius: 1,
                    colors: [
                      Colors.white,
                      Colors.white.withValues(alpha: 0.9),
                    ],
                  ).createShader(bounds);
                },
                child: widget.child,
              ),
            ),
          ),

          // VHS Tracking Lines
          if (_isGlitching)
            Positioned(
              top: _glitchOffset,
              left: 0,
              right: 0,
              height: 50,
              child: ColoredBox(
                color: Colors.white.withValues(alpha: 0.1),
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.screen,
                  child: Container(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),

          // Scan Lines
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: ScanLinePainter(
                      offset: _animation.value,
                      isGlitching: _isGlitching,
                    ),
                  );
                },
              ),
            ),
          ),

          // RGB Split Effect
          if (_isGlitching)
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.2),
                      Colors.black.withValues(alpha: 0.5),
                      Colors.white.withValues(alpha: 0.2),
                    ],
                    stops: const [0.0, 1.0],
                    begin: Alignment(-0.2 + _random.nextDouble() * 0.4, 0),
                    end: Alignment(0.2 + _random.nextDouble() * 0.4, 0),
                  ).createShader(bounds);
                },
                blendMode: BlendMode.screen,
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

          // CRT Edge Vignette
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    radius: 1.2,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Static Noise
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: NoisePainter(
                      time: _animation.value,
                      intensity: _isGlitching ? 0.3 : 0.1,
                    ),
                  );
                },
              ),
            ),
          ),

          // Horizontal Distortion Lines
          if (_isGlitching)
            Positioned.fill(
              child: CustomPaint(
                painter: HorizontalDistortionPainter(
                  offset: _glitchOffset,
                  random: _random,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ScanLinePainter extends CustomPainter {
  ScanLinePainter({required this.offset, required this.isGlitching});
  final double offset;
  final bool isGlitching;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: isGlitching ? 0.2 : 0.1)
      ..strokeWidth = 1.0;

    final lineSpacing = isGlitching ? 2.0 : 3.0;
    for (double i = 0; i < size.height; i += lineSpacing) {
      final y = (i + offset * 20) % size.height;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ScanLinePainter oldDelegate) =>
      offset != oldDelegate.offset || isGlitching != oldDelegate.isGlitching;
}

class NoisePainter extends CustomPainter {
  NoisePainter({required this.time, required this.intensity});
  final double time;
  final double intensity;
  final math.Random random = math.Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1.0;

    final numberOfPoints = (2000 * intensity).toInt();
    for (var i = 0; i < numberOfPoints; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final opacity = random.nextDouble() * intensity;

      paint.color = Colors.white.withValues(alpha: opacity);
      canvas.drawPoints(
        PointMode.points,
        [Offset(x, y)],
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(NoisePainter oldDelegate) =>
      time != oldDelegate.time || intensity != oldDelegate.intensity;
}

class HorizontalDistortionPainter extends CustomPainter {
  HorizontalDistortionPainter({required this.offset, required this.random});
  final double offset;
  final math.Random random;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 2.0;

    for (var i = 0; i < 5; i++) {
      final y = random.nextDouble() * size.height;
      final xOffset = random.nextDouble() * 20 - 10;

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width + xOffset, y + random.nextDouble() * 4 - 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(HorizontalDistortionPainter oldDelegate) => true;
}
