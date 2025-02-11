import 'dart:math' as math;

import 'package:canarslan_website/services/orientation_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

part 'switch_button_painter.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({
    required this.isSwitched,
    required this.onSwitch,
    super.key,
  });
  final bool isSwitched;
  final void Function({bool value}) onSwitch;
  @override
  SwitchButtonState createState() => SwitchButtonState();
}

class SwitchButtonState extends State<SwitchButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.isSwitched ? 'Projects' : 'Packages';
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: GestureDetector(
        onTap: () {
          widget.onSwitch(value: !widget.isSwitched);
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              alignment: Alignment.bottomCenter,
              child: CustomPaint(
                painter: SwitchButtonPainter(),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Switch to ',
                            style: GoogleFonts.inter(
                              fontSize: OrientationService.switchButtonFontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: text,
                            style: GoogleFonts.martianMono(
                              fontSize: OrientationService.switchButtonFontSize,
                              color: widget.isSwitched
                                  ? Colors.blue
                                  : Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
