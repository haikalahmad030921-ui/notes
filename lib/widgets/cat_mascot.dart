import 'package:material_ui/material_ui.dart';

/// Cute orange cat mascot wearing glasses and holding a blue book.
class CatMascot extends StatelessWidget {
  final double size;

  const CatMascot({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CatMascotPainter(),
      ),
    );
  }
}

class _CatMascotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final orangePaint = Paint()..color = const Color(0xFFFF8A1F);
    final darkOutline = Paint()
      ..color = const Color(0xFF1E1B4B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.025
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final whitePaint = Paint()..color = Colors.white;
    final pinkPaint = Paint()..color = const Color(0xFFFDA4AF);
    final bookPaint = Paint()..color = const Color(0xFF2563EB);
    final bookLightPaint = Paint()..color = const Color(0xFF60A5FA);

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.93),
        width: w * 0.56,
        height: h * 0.08,
      ),
      Paint()..color = Colors.black.withValues(alpha: 0.14),
    );

    // Tail
    final tailPath = Path()
      ..moveTo(w * 0.68, h * 0.78)
      ..quadraticBezierTo(w * 0.88, h * 0.72, w * 0.84, h * 0.52)
      ..quadraticBezierTo(w * 0.82, h * 0.46, w * 0.77, h * 0.50);
    canvas.drawPath(
      tailPath,
      Paint()
        ..color = const Color(0xFFFF8A1F)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.07
        ..strokeCap = StrokeCap.round,
    );

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.70),
        width: w * 0.42,
        height: h * 0.32,
      ),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(bodyRect, orangePaint);
    canvas.drawRRect(bodyRect, darkOutline);

    // White belly
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.72),
        width: w * 0.24,
        height: h * 0.20,
      ),
      whitePaint,
    );

    // Ears
    final leftEar = Path()
      ..moveTo(w * 0.28, h * 0.30)
      ..lineTo(w * 0.24, h * 0.10)
      ..lineTo(w * 0.40, h * 0.20)
      ..close();
    canvas.drawPath(leftEar, orangePaint);
    canvas.drawPath(leftEar, darkOutline);

    final rightEar = Path()
      ..moveTo(w * 0.72, h * 0.30)
      ..lineTo(w * 0.76, h * 0.10)
      ..lineTo(w * 0.60, h * 0.20)
      ..close();
    canvas.drawPath(rightEar, orangePaint);
    canvas.drawPath(rightEar, darkOutline);

    // Inner ears
    final leftInner = Path()
      ..moveTo(w * 0.29, h * 0.26)
      ..lineTo(w * 0.27, h * 0.14)
      ..lineTo(w * 0.37, h * 0.21)
      ..close();
    canvas.drawPath(leftInner, pinkPaint);

    final rightInner = Path()
      ..moveTo(w * 0.71, h * 0.26)
      ..lineTo(w * 0.73, h * 0.14)
      ..lineTo(w * 0.63, h * 0.21)
      ..close();
    canvas.drawPath(rightInner, pinkPaint);

    // Head
    final headRect = Rect.fromCenter(
      center: Offset(w * 0.5, h * 0.38),
      width: w * 0.52,
      height: h * 0.42,
    );
    canvas.drawOval(headRect, orangePaint);
    canvas.drawOval(headRect, darkOutline);

    // White muzzle
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.46),
        width: w * 0.26,
        height: h * 0.16,
      ),
      whitePaint,
    );

    // Glasses frames
    final glassesPaint = Paint()
      ..color = const Color(0xFF1E1B4B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.03;

    final leftEyeCenter = Offset(w * 0.39, h * 0.36);
    final rightEyeCenter = Offset(w * 0.61, h * 0.36);
    final glassRadius = w * 0.10;

    canvas.drawCircle(leftEyeCenter, glassRadius, whitePaint);
    canvas.drawCircle(rightEyeCenter, glassRadius, whitePaint);
    canvas.drawCircle(leftEyeCenter, glassRadius, glassesPaint);
    canvas.drawCircle(rightEyeCenter, glassRadius, glassesPaint);

    // Glasses bridge
    canvas.drawLine(
      Offset(w * 0.49, h * 0.36),
      Offset(w * 0.51, h * 0.36),
      glassesPaint,
    );

    // Pupils
    final pupilPaint = Paint()..color = const Color(0xFF1E1B4B);
    canvas.drawCircle(Offset(w * 0.40, h * 0.36), w * 0.04, pupilPaint);
    canvas.drawCircle(Offset(w * 0.60, h * 0.36), w * 0.04, pupilPaint);
    canvas.drawCircle(Offset(w * 0.415, h * 0.345), w * 0.015, whitePaint);
    canvas.drawCircle(Offset(w * 0.615, h * 0.345), w * 0.015, whitePaint);

    // Nose
    canvas.drawCircle(
      Offset(w * 0.5, h * 0.44),
      w * 0.022,
      Paint()..color = const Color(0xFF1E1B4B),
    );

    // Blue open book
    final leftPage = Path()
      ..moveTo(w * 0.50, h * 0.74)
      ..lineTo(w * 0.25, h * 0.68)
      ..lineTo(w * 0.27, h * 0.86)
      ..lineTo(w * 0.50, h * 0.90)
      ..close();
    final rightPage = Path()
      ..moveTo(w * 0.50, h * 0.74)
      ..lineTo(w * 0.75, h * 0.68)
      ..lineTo(w * 0.73, h * 0.86)
      ..lineTo(w * 0.50, h * 0.90)
      ..close();

    canvas.drawPath(leftPage, bookPaint);
    canvas.drawPath(rightPage, bookLightPaint);
    canvas.drawPath(leftPage, darkOutline);
    canvas.drawPath(rightPage, darkOutline);

    // Paws holding book
    canvas.drawCircle(Offset(w * 0.29, h * 0.80), w * 0.045, whitePaint);
    canvas.drawCircle(Offset(w * 0.29, h * 0.80), w * 0.045, darkOutline);
    canvas.drawCircle(Offset(w * 0.71, h * 0.80), w * 0.045, whitePaint);
    canvas.drawCircle(Offset(w * 0.71, h * 0.80), w * 0.045, darkOutline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
