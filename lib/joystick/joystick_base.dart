import 'package:flutter/material.dart';

import 'joystick.dart';

class JoystickBase extends StatelessWidget {
  final JoystickMode mode;

  const JoystickBase({
    this.mode = JoystickMode.all,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(
        painter: _JoystickBasePainter(mode),
      ),
    );
  }
}

class _JoystickBasePainter extends CustomPainter {
  _JoystickBasePainter(this.mode);

  final JoystickMode mode;

  final _centerPaint = Paint()
    ..color = const Color(0x50616161)
    ..style = PaintingStyle.fill;
  final _linePaint = Paint()
    ..color = const Color(0xFF616161)
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.width / 2);
    final radius = size.width / 2;
    canvas.drawCircle(center, radius, _centerPaint);

    if (mode != JoystickMode.horizontal) {
      // draw vertical arrows
      canvas.drawLine(Offset(center.dx - 10, center.dy - 80),
          Offset(center.dx, center.dy - 90), _linePaint);
      canvas.drawLine(Offset(center.dx + 10, center.dy - 80),
          Offset(center.dx, center.dy - 90), _linePaint);
      canvas.drawLine(Offset(center.dx - 10, center.dy + 80),
          Offset(center.dx, center.dy + 90), _linePaint);
      canvas.drawLine(Offset(center.dx + 10, center.dy + 80),
          Offset(center.dx, center.dy + 90), _linePaint);
    }

    if (mode != JoystickMode.vertical) {
      // draw horizontal arrows
      canvas.drawLine(Offset(center.dx - 80, center.dy - 10),
          Offset(center.dx - 90, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx - 80, center.dy + 10),
          Offset(center.dx - 90, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx + 80, center.dy - 10),
          Offset(center.dx + 90, center.dy), _linePaint);
      canvas.drawLine(Offset(center.dx + 80, center.dy + 10),
          Offset(center.dx + 90, center.dy), _linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}