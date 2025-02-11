import 'dart:async';
import 'dart:math';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleAsciiArtText extends StatefulWidget {
  const TitleAsciiArtText({
    required this.finalAsciiText,
    super.key,
    this.animationDuration = const Duration(seconds: 4),
    this.initialStepDuration = const Duration(milliseconds: 50),
    this.fontSize,
    this.height,
    this.letterSpacing,
  });
  final Duration animationDuration;
  final Duration initialStepDuration;
  final String finalAsciiText;
  final double? fontSize;
  final double? height;
  final double? letterSpacing;

  @override
  State<TitleAsciiArtText> createState() => _TitleAsciiArtTextState();
}

class _TitleAsciiArtTextState extends State<TitleAsciiArtText> {
  static const List<String> characterSets = [
    r'@#\$%&*+=<>', // High density
    '''ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789''', // Medium density
    r'''!@#\$%^&*()_+-=[]{}|;:'",.<>/?''', // Low density
    '''~` .,;'"-_()[]{}|/<>''', // Very low density
  ];

  late String currentText;
  late Timer _timer;
  late DateTime _startTime;
  final Random _random = Random();
  late Duration _currentStepDuration;

  @override
  void initState() {
    super.initState();
    currentText = widget.finalAsciiText;
    _currentStepDuration = widget.initialStepDuration;
    _startAnimation();
  }

  void _startAnimation() {
    _startTime = DateTime.now();
    _scheduleNextUpdate();
  }

  void _scheduleNextUpdate() {
    _timer = Timer(_currentStepDuration, _updateAnimation);
  }

  void _updateAnimation() {
    final elapsedTime = DateTime.now().difference(_startTime);

    if (elapsedTime >= widget.animationDuration) {
      _completeAnimation();
      return;
    }

    final progress =
        elapsedTime.inMilliseconds / widget.animationDuration.inMilliseconds;
    final currentSetIndex = (progress * characterSets.length).floor();
    _currentStepDuration = widget.initialStepDuration +
        Duration(milliseconds: 15 * currentSetIndex);

    setState(() {
      currentText = _generateAnimatedText(currentSetIndex);
    });

    _scheduleNextUpdate();
  }

  String _generateAnimatedText(int characterSetIndex) {
    final currentCharacterSet = characterSets[characterSetIndex];
    return widget.finalAsciiText.split('').map((char) {
      if (char.trim().isEmpty) return char;
      if (RegExp(r'[\/\\_|\-]').hasMatch(char)) {
        return currentCharacterSet[_random.nextInt(currentCharacterSet.length)];
      }
      return char;
    }).join();
  }

  void _completeAnimation() {
    setState(() {
      currentText = widget.finalAsciiText;
    });
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      currentText,
      style: GoogleFonts.courierPrime(
        fontWeight: FontWeight.bold,
        fontSize: widget.fontSize ?? OrientationService.asciiArtTitleFontSize,
        color: Colors.white,
        height: widget.fontSize == null ? 1 : widget.height,
        letterSpacing: widget.letterSpacing,
        shadows: [
          Shadow(
            color: Colors.white.withValues(alpha: 0.8),
            blurRadius: 3,
          ),
          Shadow(
            color: Colors.white.withValues(alpha: 0.5),
            blurRadius: 30,
          ),
        ],
      ),
    );
  }
}
