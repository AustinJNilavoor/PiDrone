import 'dart:math';
import 'dart:ui';

import 'joystick.dart';

abstract class StickOffsetCalculator {
  Offset calculate({
    // required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  });
}

class CircleStickOffsetCalculator implements StickOffsetCalculator {
  const CircleStickOffsetCalculator();

  @override
  Offset calculate({
    // required JoystickMode mode,
    required Offset startDragStickPosition,
    required Offset currentDragStickPosition,
    required Size baseSize,
  }) {
    double x = currentDragStickPosition.dx - startDragStickPosition.dx;
    double y = currentDragStickPosition.dy - startDragStickPosition.dy;
    final radius = baseSize.width / 2;

    final isPointInCircle = x * x + y * y < radius * radius;

    if (!isPointInCircle) {
      final mult = sqrt(radius * radius / (y * y + x * x));
      x *= mult;
      y *= mult;
    }

    final xOffset = x / radius;
    final yOffset = y / radius;

    return Offset(xOffset, yOffset);
  }
}