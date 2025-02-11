part of 'switch_button.dart';

class SwitchButtonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Üst kenarların içeri doğru kaydırma miktarı
    final insetAmount = size.width *
        0.1; // Bu değeri artırıp azaltarak şekli ayarlayabilirsiniz

    // Sol üst köşe
    path
      ..moveTo(insetAmount, 0)
      // Sağ üst köşe
      ..lineTo(size.width - insetAmount, 0)
      // Sağ alt köşe
      ..lineTo(size.width, size.height)
      // Sol alt köşe
      ..lineTo(0, size.height)
      // Başlangıç noktasına geri dön
      ..close();

    // Clip the canvas to the path
    canvas.clipPath(path);

    // Fill the background with the specified color
    final backgroundPaint = Paint()..color = const Color(0xFF071235);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Kesikli çizgi efekti için path'i parçalara böl
    final dashedPath = extractPath(path);

    // Çiz
    canvas.drawPath(dashedPath, paint);
  }

  Path extractPath(Path path) {
    const dashWidth = 6.0;
    const dashSpace = 2.0;
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
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
            dashedPath
              ..moveTo(start.dx, start.dy)
              ..lineTo(end.dx, end.dy);
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
