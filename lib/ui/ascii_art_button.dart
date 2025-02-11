import 'dart:async';
import 'dart:math';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Animation direction enum
enum AnimationDirection { leftToRight, rightToLeft }

// Constants
class AsciiConstants {
  static const animationDuration = Duration(milliseconds: 200);
  static const binaryUpdateInterval = Duration(milliseconds: 30);
  static const disappearingInterval = Duration(milliseconds: 10);
  static const asciiLineInterval = Duration(milliseconds: 40);
  static const initialDisappearDelay = Duration(milliseconds: 1200);

  static const defaultTextStyle = TextStyle(
    color: Colors.white,
    letterSpacing: 1.4,
  );

  static const textShadows = [
    Shadow(color: Colors.white, blurRadius: 3),
    Shadow(color: Colors.white, blurRadius: 30),
  ];
}

// Size measuring widget
class MeasureSize extends StatefulWidget {
  const MeasureSize({
    required this.onChange,
    required this.child,
    super.key,
  });
  final Widget child;
  final void Function(Size) onChange;

  @override
  MeasureSizeState createState() => MeasureSizeState();
}

class MeasureSizeState extends State<MeasureSize> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SizeReporter(onChange: widget.onChange),
      child: widget.child,
    );
  }
}

class _SizeReporter extends CustomPainter {
  _SizeReporter({required this.onChange});
  final void Function(Size) onChange;
  Size? _oldSize;

  @override
  void paint(Canvas canvas, Size size) {
    if (size != _oldSize) {
      _oldSize = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onChange(size));
    }
  }

  @override
  bool shouldRepaint(_SizeReporter oldDelegate) => true;
}

// Main Button Widget
class AsciiArtButton extends StatefulWidget {
  const AsciiArtButton({
    required this.label,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.direction,
    required this.completedAsciiAnimation,
    required this.asciiAnimationTrigger,
    super.key,
    this.padding,
  });
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final AnimationDirection direction;
  final bool asciiAnimationTrigger;
  final VoidCallback completedAsciiAnimation;

  @override
  AsciiArtButtonState createState() => AsciiArtButtonState();
}

class AsciiArtButtonState extends State<AsciiArtButton>
    with TickerProviderStateMixin {
  // Animation controllers and state
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  Timer? _timer;
  bool _startAnimating = false;
  bool _startDisappearing = false;
  int _disappearingStep = 0;
  bool _startedAsciiLineAnimation = false;
  Size? _buttonSize;

  final String _initialBinaryString = List.generate(
    3,
    (_) => '010101010101010010101010101010'.substring(
      0,
      OrientationService.asciiButtonWidthAsciiCharacterCount,
    ),
  ).join('\n');
  String _verticalAsciiAnimation = '';
  String _horizontalAsciiAnimation = '';
  String _labelAnimation = '';
  List<String> _currentLines = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _currentLines = _initialBinaryString.split('\n');
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: AsciiConstants.animationDuration,
    );

    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _randomizeBinaryString(String input) {
    final random = Random();
    return input
        .split('')
        .map((char) => char == ' ' ? ' ' : (random.nextBool() ? '1' : '0'))
        .join();
  }

  void _startAnimation() {
    if (_startAnimating) return;

    setState(() => _startAnimating = true);
    _startBinaryAnimation();
    _scheduleDisappearingAnimation();
  }

  void _startBinaryAnimation() {
    _timer = Timer.periodic(AsciiConstants.binaryUpdateInterval, (timer) {
      if (!_startAnimating || !mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_startDisappearing) {
          _handleDisappearingAnimation();
        } else {
          _updateBinaryAnimation();
        }
      });
    });
  }

  void _handleDisappearingAnimation() {
    var allLinesEmpty = true;

    for (var i = 0; i < _currentLines.length; i++) {
      final currentLine = _currentLines[i];
      final result = _processDisappearingLine(currentLine, i);

      _currentLines[i] = result.newLine;
      allLinesEmpty = allLinesEmpty && result.isEmpty;
    }

    if (allLinesEmpty) {
      _timer?.cancel();
      _startAnimating = false;
    }
  }

  ({String newLine, bool isEmpty}) _processDisappearingLine(
    String currentLine,
    int index,
  ) {
    if (widget.direction == AnimationDirection.leftToRight) {
      return _processLeftToRight(currentLine, index);
    }
    return _processRightToLeft(currentLine, index);
  }

  ({String newLine, bool isEmpty}) _processLeftToRight(
    String currentLine,
    int index,
  ) {
    final emptyCount = _disappearingStep + index;
    final remainingLength = currentLine.length - emptyCount;

    if (remainingLength <= 0) {
      return (newLine: ' ' * currentLine.length, isEmpty: true);
    }

    _updateLabelAnimation(currentLine, remainingLength);

    final emptyPart = ' ' * emptyCount;
    final randomizedPart =
        _randomizeBinaryString(currentLine.substring(emptyCount));

    return (newLine: emptyPart + randomizedPart, isEmpty: false);
  }

  ({String newLine, bool isEmpty}) _processRightToLeft(
    String currentLine,
    int index,
  ) {
    final remainingLength = currentLine.length - _disappearingStep - index;

    if (remainingLength <= 0) {
      return (newLine: ' ' * currentLine.length, isEmpty: true);
    }

    _updateLabelAnimation(currentLine, remainingLength);

    final randomizedPart =
        _randomizeBinaryString(currentLine.substring(0, remainingLength));
    final emptyPart = ' ' * (_disappearingStep + index);

    return (newLine: randomizedPart + emptyPart, isEmpty: false);
  }

  void _updateLabelAnimation(String currentLine, int remainingLength) {
    final textPercentage = (100 / widget.label.length) * _labelAnimation.length;
    final percentage =
        ((currentLine.length - remainingLength) / currentLine.length) * 100;

    if (percentage > textPercentage || textPercentage == 0) {
      setState(() {
        if (widget.direction == AnimationDirection.leftToRight) {
          _labelAnimation += widget.label[_labelAnimation.length];
        } else {
          _labelAnimation =
              widget.label[widget.label.length - _labelAnimation.length - 1] +
                  _labelAnimation;
        }
      });
    }
  }

  void _updateBinaryAnimation() {
    _currentLines =
        _initialBinaryString.split('\n').map(_randomizeBinaryString).toList();
  }

  void _scheduleDisappearingAnimation() {
    Future.delayed(AsciiConstants.initialDisappearDelay, () {
      if (!mounted) return;

      setState(() => _startDisappearing = true);

      Timer.periodic(AsciiConstants.disappearingInterval, (timer) {
        if (!mounted || !_startDisappearing) {
          timer.cancel();
          return;
        }

        setState(() {
          if (_disappearingStep <= _currentLines[0].length) {
            _disappearingStep++;
          } else {
            timer.cancel();
          }
        });
      });
    });
  }

  void _startAsciiAnimation() {
    _startVerticalAnimation();
  }

  void _startVerticalAnimation() {
    Timer.periodic(AsciiConstants.asciiLineInterval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_verticalAsciiAnimation.split('\n').length >= 4) {
          timer.cancel();
          _startHorizontalAnimation();
        } else {
          _verticalAsciiAnimation = _verticalAsciiAnimation.isEmpty
              ? '|'
              : '$_verticalAsciiAnimation\n|';
        }
      });
    });
  }

  void _startHorizontalAnimation() {
    Timer.periodic(AsciiConstants.asciiLineInterval, (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() => _horizontalAsciiAnimation += '_');

      if (_isHorizontalAnimationComplete()) {
        timer.cancel();
        widget.completedAsciiAnimation();
      }
    });
  }

  bool _isHorizontalAnimationComplete() {
    final textSpan = TextSpan(
      text: _horizontalAsciiAnimation,
      style: AsciiConstants.defaultTextStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: (_buttonSize?.width ?? 0) / 1.85);
    return textPainter.didExceedMaxLines;
  }

  String get _borderText {
    final columnVertical = '%' *
        (widget.width.toInt() * 2 +
            OrientationService.asciiButtonWidthCharacterCount);
    final columnCenter = ' ' *
        (widget.width.toInt() * 2 +
            OrientationService.asciiButtonWidthCharacterCount);

    return '''
  :+$columnVertical*:.
.=#:.$columnCenter:#+.
${List.generate(widget.height.toInt() * 2, (index) => '.*+.$columnCenter  =*:').join('\n')}
.#*..$columnCenter:#+.
  :+$columnVertical*:.''';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.asciiAnimationTrigger && !_startedAsciiLineAnimation) {
      _startedAsciiLineAnimation = true;
      _startAsciiAnimation();
    }

    _startAnimation();

    return Column(
      children: [
        _buildMainButton(),
        _buildAsciiLines(),
      ],
    );
  }

  Widget _buildMainButton() {
    return MeasureSize(
      onChange: (size) => setState(() => _buttonSize = size),
      child: _buildInteractiveButton(),
    );
  }

  Widget _buildInteractiveButton() {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _controller.reverse();
          widget.onPressed();
        },
        child: _buildAnimatedButton(),
      ),
    );
  }

  Widget _buildAnimatedButton() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: ColoredBox(
        color: Colors.transparent,
        child: IgnorePointer(
          child: Stack(
            children: [
              _buildBorderText(),
              _buildCenterLabel(),
              _buildBinaryOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBorderText() {
    return Text(
      _borderText,
      style: GoogleFonts.courierPrime(
        color: Colors.white,
        fontSize: 3,
        height: 0.5,
        shadows: AsciiConstants.textShadows,
      ),
    );
  }

  Widget _buildCenterLabel() {
    return Positioned.fill(
      child: Center(
        child: Stack(
          children: [
            SelectableText(
              '${widget.label}\n',
              style: GoogleFonts.courierPrime(
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 0.6
                  ..color = Colors.transparent,
                fontSize: 20,
              ),
            ),
            _buildAnimatedLabel(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedLabel() {
    return Positioned.fill(
      child: Align(
        alignment: widget.direction == AnimationDirection.leftToRight
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: SelectableText(
          '$_labelAnimation\n',
          style: GoogleFonts.courierPrime(
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 0.6
              ..color = Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildBinaryOverlay() {
    return Text(
      _currentLines.join('\n'),
      style: GoogleFonts.courierPrime(
        color: Colors.white,
        fontSize: 10,
        height: 1,
        shadows: AsciiConstants.textShadows,
      ),
    );
  }

  Widget _buildAsciiLines() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildHorizontalLine(isLeft: true),
        _buildVerticalLine(),
        _buildHorizontalLine(isLeft: false),
      ],
    );
  }

  Widget _buildHorizontalLine({required bool isLeft}) {
    final shouldShow =
        widget.direction == AnimationDirection.leftToRight ? !isLeft : isLeft;

    return SizedBox(
      width: (_buttonSize?.width ?? 0) / 1.85,
      child: Text(
        _horizontalAsciiAnimation,
        maxLines: 1,
        textAlign: isLeft ? TextAlign.end : TextAlign.start,
        style: AsciiConstants.defaultTextStyle.copyWith(
          color: shouldShow ? Colors.white : Colors.transparent,
        ),
      ),
    );
  }

  Widget _buildVerticalLine() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Text(
        _verticalAsciiAnimation,
        style: AsciiConstants.defaultTextStyle.copyWith(height: 1),
      ),
    );
  }
}
