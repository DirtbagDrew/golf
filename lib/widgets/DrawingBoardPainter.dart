import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class DrawingBoardPainter extends CustomPainter {
  List<Offset> _offsets;

  DrawingBoardPainter(this._offsets) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.deepPurple
      ..isAntiAlias = true
      ..strokeWidth = 5;
    for (var i = 0; i < _offsets.length - 1; i++) {
      if (_offsets[i] != null && _offsets[i + 1] != null) {
        if (_distanceBetween(_offsets[i], _offsets[i + 1]) > 20) {
          canvas.drawPoints(PointMode.points, [_offsets[i]], paint);
          canvas.drawPoints(PointMode.points, [_offsets[i + 1]], paint);
        } else {
          canvas.drawLine(_offsets[i], _offsets[i + 1], paint);
        }
      } else if (_offsets[i] != null && _offsets[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [_offsets[i]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  double _distanceBetween(Offset offsetA, Offset offsetB) =>
      sqrt(pow(offsetA.dx - offsetB.dx, 2) + pow(offsetA.dy - offsetB.dy, 2));
}
