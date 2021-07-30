

import 'dart:math';

import 'package:flutter/material.dart';

class ApertureLeafPainter extends CustomPainter {

  final double rotationRadians;
  final double _borderWidth;
  final Color _borderColor;
  final Color _fillColor;

  final Paint _borderPaint = Paint();
  final Paint _fillPaint = Paint();



  ApertureLeafPainter({
    required borderWidth,
    required this.rotationRadians,
    borderColor,
    fillColor
  }) :
        _borderWidth = borderWidth,
        _borderColor = borderColor ?? Colors.black,
        _fillColor = fillColor ?? Colors.grey.shade900;



  @override
  void paint(Canvas canvas, Size size) {
    _borderPaint.color = _borderColor;
    _fillPaint.color = _fillColor;

    final width = size.width;
    final height = sqrt((pow(width, 2) - pow((width / 2), 2)));

    canvas.save();
    canvas.rotate(rotationRadians);

    Path borderPath = Path()
    ..moveTo(0, width)
    ..lineTo(width / 2, width - height) // top
    ..lineTo(width, width)
    ..close();

    canvas.drawPath(borderPath, _borderPaint);
    
    Path fillPath = Path()
    ..moveTo(_borderWidth * 2, width - _borderWidth)
    ..lineTo(width / 2, width - height + (_borderWidth * 2))
    ..lineTo(width - (_borderWidth * 2), width - _borderWidth)
    ..close();

    canvas.drawPath(fillPath, _fillPaint);


    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}