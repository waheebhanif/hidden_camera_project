
import 'dart:ui';

import '../../../utils/app_exports.dart';

class ScanOverlayPainter extends CustomPainter {
  final bool isScanning;
  final double irStrength;

  ScanOverlayPainter({
    required this.isScanning,
    required this.irStrength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isScanning) return;

    final paint = Paint()
      ..color = _getStrengthColor(irStrength)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw center targeting box
    final centerRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.3,
      height: size.height * 0.3,
    );

    canvas.drawRect(centerRect, paint);

    // Draw corner indicators
    final cornerSize = 20.0;
    final cornerPaint = Paint()
      ..color = _getStrengthColor(irStrength)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Top-left corner
    canvas.drawLine(
      Offset(0, cornerSize),
      Offset(0, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, 0),
      Offset(cornerSize, 0),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(size.width - cornerSize, 0),
      Offset(size.width, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width, cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(0, size.height - cornerSize),
      Offset(0, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(cornerSize, size.height),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(size.width - cornerSize, size.height),
      Offset(size.width, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - cornerSize),
      Offset(size.width, size.height),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(ScanOverlayPainter oldDelegate) {
    return oldDelegate.isScanning != isScanning ||
        oldDelegate.irStrength != irStrength;
  }

  Color _getStrengthColor(double strength) {
    if (strength > 75) return Colors.red;
    if (strength > 30) return Colors.redAccent;
    if (strength > 25) return Colors.orange;
    return Colors.green;
  }
}

class IRMeterPainter extends CustomPainter {
  final double strength;
  final bool isScanning;

  IRMeterPainter({
    required this.strength,
    required this.isScanning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.2;

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(center, radius, bgPaint);

    // Draw strength arc
    final strengthPaint = Paint()
      ..color = _getStrengthColor(strength)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14 / 2,
      3.14 * 2 * (strength / 100),
      false,
      strengthPaint,
    );

    // Draw scanning indicator
    if (isScanning) {
      final scanPaint = Paint()
        ..color = Colors.blue.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(center, radius + 15, scanPaint);
    }
  }

  @override
  bool shouldRepaint(IRMeterPainter oldDelegate) {
    return oldDelegate.strength != strength ||
        oldDelegate.isScanning != isScanning;
  }

  Color _getStrengthColor(double strength) {
    if (strength > 75) return Colors.red;
    if (strength > 30) return Colors.redAccent;
    if (strength > 25) return Colors.yellow;
    return Colors.green;
  }
}

class Vector2 {
  final double x;
  final double y;

  Vector2(this.x, this.y);
}
