import 'dart:async';

import 'package:canarslan_website/constants/ascii_constants.dart';
import 'package:canarslan_website/controllers/projects_controller/projects_page_controller.dart';
import 'package:canarslan_website/services/html_service.dart';
import 'package:canarslan_website/services/javascript_service.dart';
import 'package:canarslan_website/services/orientation_service.dart';
import 'package:canarslan_website/ui/ascii_line_painter.dart';
import 'package:canarslan_website/ui/padding.dart';
import 'package:canarslan_website/ui/switch_button/switch_button.dart';
import 'package:canarslan_website/ui/title_ascii_art_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
part 'containers/ascii_animation_container_projects.dart';
part 'project_section/project_section.dart';
part 'project_section/competitions_and_certificates_section.dart';
part 'packages_section/packages_section.dart';
part 'packages_section/package_painter.dart';
part 'containers/ascii_animation_controller_packages.dart';

class AsciiAnimationContainer extends StatefulWidget {
  const AsciiAnimationContainer({
    super.key,
  });

  @override
  State<AsciiAnimationContainer> createState() =>
      _AsciiAnimationContainerState();
}

class _AsciiAnimationContainerState extends State<AsciiAnimationContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _verticalLineAnimation;
  late Animation<double> _horizontalLineAnimation;
  late Animation<double> _containerVerticalAnimation;
  late Animation<double> _containerBottomAnimation;
  final controller = Get.put(ProjectsPageController());
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (4000 * 1).round()), // Hızı ayarladım
      vsync: this,
    );

    _verticalLineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.25, curve: Curves.linear),
      ),
    );

    _horizontalLineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.5, curve: Curves.linear),
      ),
    );

    _containerVerticalAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.75, curve: Curves.linear),
      ),
    );

    _containerBottomAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.linear),
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _containerBottomAnimation,
      builder: (context, child) {
        final visibleHeight = MediaQuery.of(context).size.height *
            (0.3 + (0.85 * _containerVerticalAnimation.value));

        return Stack(
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: visibleHeight / 90.h,
                child: SizedBox(
                  height: 90.h,
                  width: 100.w,
                  child: SizedBox(
                    child: CustomPaint(
                      size: Size(100.w, 90.h),
                      painter: AsciiAnimationPainter(
                        verticalLineProgress: _verticalLineAnimation,
                        horizontalLineProgress: _horizontalLineAnimation,
                        containerVerticalProgress: _containerVerticalAnimation,
                        containerBottomProgress: _containerBottomAnimation,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(
                      top: (90.h * 0.3), bottom: 30.h - (90.h * 0.3)),
                  width: 90.w,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SizedBox(
                            height: 85.h,
                            child: Obx(() => controller.switchButton.value
                                ? const _Packages()
                                : const _Projects()))),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: (_verticalLineAnimation.value) * (90.h * 0.3),
                  width: 90.w,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: AppPadding(
                      tPadding: 90.h * 0.3 - 4.h,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: SizedBox(
                          width: OrientationService.switchButtonWidth,
                          height: 4.h,
                          child: SizedBox(
                              width: 10.w,
                              height: 4.h,
                              child: Obx(
                                () => SwitchButton(
                                  isSwitched: controller.switchButton.value,
                                  onSwitch: (bool) {
                                    setState(() {
                                      controller.switchButton.value =
                                          !controller.switchButton.value;
                                    });
                                  },
                                ),
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AsciiAnimationPainter extends CustomPainter {
  final Animation<double> verticalLineProgress;
  final Animation<double> horizontalLineProgress;
  final Animation<double> containerVerticalProgress;
  final Animation<double> containerBottomProgress;

  // Çizgi özelliklerini ayarladım
  static const double dashWidth = 6; // Kesik çizgi uzunluğu
  static const double dashSpace = 2; // Kesik çizgi aralığı
  static const double lineThickness = 1.2; // Çizgi kalınlığı

  AsciiAnimationPainter({
    required this.verticalLineProgress,
    required this.horizontalLineProgress,
    required this.containerVerticalProgress,
    required this.containerBottomProgress,
  }) : super(
            repaint: Listenable.merge([
          verticalLineProgress,
          horizontalLineProgress,
          containerVerticalProgress,
          containerBottomProgress,
        ]));

  void drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path();
    final dash = dashWidth;
    final space = dashSpace;
    final startPoint = start;
    final endPoint = end;

    final dx = endPoint.dx - startPoint.dx;
    final dy = endPoint.dy - startPoint.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final unitX = dx / distance;
    final unitY = dy / distance;

    var currentX = startPoint.dx;
    var currentY = startPoint.dy;
    var remainingDistance = distance;

    var isDrawing = true;

    while (remainingDistance > 0) {
      final stepDistance = isDrawing ? dash : space;
      final nextX =
          currentX + unitX * math.min(stepDistance, remainingDistance);
      final nextY =
          currentY + unitY * math.min(stepDistance, remainingDistance);

      if (isDrawing) {
        path.moveTo(currentX, currentY);
        path.lineTo(nextX, nextY);
      }

      currentX = nextX;
      currentY = nextY;
      remainingDistance -= stepDistance;
      isDrawing = !isDrawing;
    }

    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = lineThickness
      ..style = PaintingStyle.stroke;

    final centerX = 50.w;
    final containerWidth = 90.w;
    final containerHeight = 85.h;

    // İlk dikey çizgi
    if (verticalLineProgress.value > 0) {
      final verticalLength = size.height * 0.3 * verticalLineProgress.value;
      drawDashedLine(
        canvas,
        Offset(centerX, 0),
        Offset(centerX, verticalLength),
        paint,
      );
    }

    // İlk yatay çizgi
    if (horizontalLineProgress.value > 0) {
      final startX =
          centerX - (containerWidth / 2 * horizontalLineProgress.value);
      final endX =
          centerX + (containerWidth / 2 * horizontalLineProgress.value);
      drawDashedLine(
        canvas,
        Offset(startX, size.height * 0.3),
        Offset(endX, size.height * 0.3),
        paint,
      );
    }

    // Container dikey çizgileri
    if (containerVerticalProgress.value > 0) {
      final leftX = centerX - containerWidth / 2;
      final rightX = centerX + containerWidth / 2;
      final verticalLength = containerHeight * containerVerticalProgress.value;

      drawDashedLine(
        canvas,
        Offset(leftX, size.height * 0.3),
        Offset(leftX, size.height * 0.3 + verticalLength),
        paint,
      );

      drawDashedLine(
        canvas,
        Offset(rightX, size.height * 0.3),
        Offset(rightX, size.height * 0.3 + verticalLength),
        paint,
      );
    }

    // Container alt çizgi - ortada birleşen
    if (containerBottomProgress.value > 0) {
      final startX = centerX - containerWidth / 2;
      final endX = centerX + containerWidth / 2;
      final y = size.height * 0.3 + containerHeight;

      // Sol taraftan ortaya
      drawDashedLine(
        canvas,
        Offset(startX, y),
        Offset(
            startX + (containerWidth / 2 * containerBottomProgress.value), y),
        paint,
      );

      // Sağ taraftan ortaya
      drawDashedLine(
        canvas,
        Offset(endX, y),
        Offset(endX - (containerWidth / 2 * containerBottomProgress.value), y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AsciiAnimationPainter oldDelegate) {
    return true;
  }
}
