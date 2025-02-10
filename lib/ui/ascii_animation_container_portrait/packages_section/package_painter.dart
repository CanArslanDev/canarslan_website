part of '../ascii_animation_container.dart';

class PackagePainter extends CustomPainter {
  final double borderRadius;

  PackagePainter({this.borderRadius = 8.0}); // Varsayılan border radius değeri

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Köşe noktaları için radius'ları tanımlama
    final topLeftRadius = Radius.circular(borderRadius);
    final topRightRadius = Radius.circular(borderRadius);
    final bottomRightRadius = Radius.circular(borderRadius);
    final bottomLeftRadius = Radius.circular(borderRadius);

    // Border radius'lu path oluşturma
    path.addRRect(RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.width, size.height),
      topLeft: topLeftRadius,
      topRight: topRightRadius,
      bottomRight: bottomRightRadius,
      bottomLeft: bottomLeftRadius,
    ));

    // Kesikli çizgi efekti için path'i parçalara böl
    final dashedPath = extractPath(path);

    // Çiz
    canvas.drawPath(dashedPath, paint);
  }

  Path extractPath(Path path) {
    const dashWidth = 6.0;
    const dashSpace = 2.0;
    final dashedPath = Path();

    for (var metric in path.computeMetrics()) {
      var distance = 0.0;
      var isDrawing = true;

      while (distance < metric.length) {
        final nextDistance = distance + (isDrawing ? dashWidth : dashSpace);

        if (isDrawing) {
          final start = metric.getTangentForOffset(distance)?.position;
          final end = metric
              .getTangentForOffset(math.min(nextDistance, metric.length))
              ?.position;

          if (start != null && end != null) {
            dashedPath.moveTo(start.dx, start.dy);
            dashedPath.lineTo(end.dx, end.dy);
          }
        }

        distance = nextDistance;
        isDrawing = !isDrawing;
      }
    }

    return dashedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
