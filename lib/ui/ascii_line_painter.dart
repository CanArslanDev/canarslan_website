import 'dart:math' as math;

import 'package:flutter/material.dart';

class AsciiLinePainter extends CustomPainter {
  AsciiLinePainter({
    this.isVerticalLine,
    this.isHorizontalLine,
  });
  final bool? isVerticalLine;
  final bool? isHorizontalLine;

  static const double dashWidth = 6;
  static const double dashSpace = 2;
  static const double lineThickness = 1.2;

  void drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    final path = Path();
    const dash = dashWidth;
    const space = dashSpace;
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
        path
          ..moveTo(currentX, currentY)
          ..lineTo(nextX, nextY);
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

    // Dikey çizgi
    if (isVerticalLine != null && isVerticalLine!) {
      drawDashedLine(
        canvas,
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        paint,
      );
    }

    // Yatay çizgi
    if (isHorizontalLine != null && isHorizontalLine!) {
      drawDashedLine(
        canvas,
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant AsciiLinePainter oldDelegate) {
    return true;
  }
}
