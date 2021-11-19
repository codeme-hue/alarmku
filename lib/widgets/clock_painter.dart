import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final DateTime _dateTime;

  ClockPainter(this._dateTime);
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.width / 2;
    Offset center = Offset(centerX, centerY);

    // hour dial
    var hourX = centerX +
        size.width * 0.25 * math.cos(_dateTime.hour * 30 * math.pi / 180);
    var hourY = centerX +
        size.width * 0.25 * math.sin(_dateTime.hour * 30 * math.pi / 180);
    canvas.drawLine(
        center,
        Offset(hourX, hourY),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10);
    // minutes dial
    var minX = centerX +
        size.width * 0.35 * math.cos(_dateTime.minute * 6 * math.pi / 180);
    var minY = centerX +
        size.width * 0.35 * math.sin(_dateTime.minute * 6 * math.pi / 180);
    canvas.drawLine(
        center,
        Offset(minX, minY),
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10);
    // center
    canvas.drawCircle(center, 10, Paint()..color = Colors.amber);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}