import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/app_resources.dart';
import 'package:flutter_realtime_object_detection/models/recognition.dart';
import 'package:flutter_realtime_object_detection/services/tensorflow_service.dart';

class ConfidenceWidget extends StatelessWidget {
  final List<Recognition> entities;
  final int previewWidth;
  final int previewHeight;
  final double screenWidth;
  final double screenHeight;
  final ModelType type;

  const ConfidenceWidget(
      {Key? key,
      required this.entities,
      required this.previewWidth,
      required this.previewHeight,
      required this.screenWidth,
      required this.screenHeight,
      required this.type})
      : super(key: key);

  List<Widget> _renderHeightLineEntities() {
    List<Widget> results = <Widget>[];
    results = this.entities.map((entity) {
      var _x = entity.rect.x;
      var _y = entity.rect.y;
      var _w = entity.rect.w;
      var _h = entity.rect.h;

      var screenRatio = this.screenHeight / this.screenWidth;
      var previewRatio = this.previewHeight / this.previewWidth;

      var scaleWidth, scaleHeight, x, y, w, h;
      if (screenRatio > previewRatio) {
        scaleHeight = screenHeight;
        scaleWidth = screenHeight / previewRatio;
        var difW = (scaleWidth - screenWidth) / scaleWidth;
        x = (_x - difW / 2) * scaleWidth;
        w = _w * scaleWidth;
        if (_x < difW / 2) {
          w -= (difW / 2 - _x) * scaleWidth;
        }
        y = _y * scaleHeight;
        h = _h * scaleHeight;
      } else {
        scaleHeight = screenWidth * previewRatio;
        scaleWidth = screenWidth;
        var difH = (scaleHeight - screenHeight) / scaleHeight;
        x = _x * scaleWidth;
        w = _w * scaleWidth;
        y = (_y - difH / 2) * scaleHeight;
        h = _h * scaleHeight;
        if (_y < difH / 2) {
          h -= (difH / 2 - _y) * scaleHeight;
        }
      }
      return Positioned(
        left: max(0, x),
        top: max(0, y),
        width: w,
        height: h,
        child: Container(
          padding: EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red, width: 2.0),
          ),
          child: Text(
            '${entity.detectedClass} ${(entity.confidenceInClass * 100).toStringAsFixed(0)}%',
            style: AppTextStyles.regularTextStyle(color: Colors.red, fontSize: AppFontSizes.extraExtraSmall, backgroundColor: AppColors.white),
          ),
        ),
      );
    }).toList();
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _renderHeightLineEntities(),
    );
  }
}
