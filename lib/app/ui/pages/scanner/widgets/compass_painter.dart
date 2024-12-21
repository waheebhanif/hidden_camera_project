import 'package:hidden_camera_detector/app/ui/utils/app_exports.dart';

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.blue;

    // Draw compass circle
    canvas.drawCircle(center, radius, paint);

    // Draw North indicator
    final northPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.red;

    final path = Path()
      ..moveTo(center.dx, center.dy - radius)
      ..lineTo(center.dx - 10, center.dy)
      ..lineTo(center.dx + 10, center.dy)
      ..close();

    canvas.drawPath(path, northPaint);

    // Draw cardinal points
    final textPainter = TextPainter(
      // textDirection: TextDirection.LTR,
      textAlign: TextAlign.center,
    );

    _drawCardinalPoint(canvas, center, radius, 'N', textPainter, 0);
    _drawCardinalPoint(canvas, center, radius, 'E', textPainter, 90);
    _drawCardinalPoint(canvas, center, radius, 'S', textPainter, 180);
    _drawCardinalPoint(canvas, center, radius, 'W', textPainter, 270);
  }

  void _drawCardinalPoint(Canvas canvas, Offset center, double radius,
      String text, TextPainter painter, double angle) {
    painter.text = TextSpan(
      text: text,
      style: TextStyle(color: Colors.black, fontSize: 16),
    );

    painter.layout();

    final rotation = angle * pi / 180;
    final offset = Offset(
      center.dx + (radius + 20) * cos(rotation - pi / 2) - painter.width / 2,
      center.dy + (radius + 20) * sin(rotation - pi / 2) - painter.height / 2,
    );

    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
