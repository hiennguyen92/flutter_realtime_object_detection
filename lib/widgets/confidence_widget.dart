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

  final double heightAppBar;

  const ConfidenceWidget(
      {Key? key,
      required this.heightAppBar,
      required this.entities,
      required this.previewWidth,
      required this.previewHeight,
      required this.screenWidth,
      required this.screenHeight,
      required this.type})
      : super(key: key);

  List<Widget> _renderPoseNet() {
    var lists = <Widget>[];
    this.entities.forEach((re) {
      var list = re.keypoints!.map<Widget>((k) {
        var _x = k.x;
        var _y = k.y;
        var scaleWidth, scaleHeight, x, y;

        var screenRatio = this.screenHeight / this.screenWidth;
        var previewRatio = this.previewHeight / this.previewWidth;

        if (screenRatio > previewRatio) {
          scaleWidth = screenHeight / previewRatio;
          scaleHeight = screenHeight;
          var difW = (scaleWidth - screenWidth) / scaleWidth;
          x = (_x - difW / 2) * scaleWidth;
          y = _y * scaleHeight;
        } else {
          scaleHeight = screenWidth * previewRatio;
          scaleWidth = screenWidth;
          var difH = (scaleHeight - screenHeight) / scaleHeight;
          x = _x * scaleWidth;
          y = (_y - difH / 2) * scaleHeight;
        }
        return Positioned(
            left: x - 15,
            top: y - heightAppBar,
            width: 100,
            height: 15,
            child: Row(children: <Widget>[
              Icon(Icons.api, size: AppFontSizes.small, color: AppColors.blue),
              Text(" ${k.part}",
                  style: AppTextStyles.regularTextStyle(
                      color: Colors.red,
                      fontSize: AppFontSizes.extraExtraSmall,
                      backgroundColor: AppColors.white))
            ]));
      }).toList();
      lists..addAll(list);
    });
    return lists;
  }

  List<Widget> _renderStringEntities() {
    List<Widget> results = <Widget>[];
    double offset = 0;
    results = this.entities.map((entity) {
      offset = offset + 20;
      print(entity);
      return Positioned(
          left: 10,
          top: offset,
          width: this.screenWidth,
          height: this.screenHeight,
          child: Text(
            '${entity.label ?? ''} ${((entity.confidence ?? 0) * 100).toStringAsFixed(0)}%',
            style: AppTextStyles.regularTextStyle(
                color: Colors.red,
                fontSize: AppFontSizes.extraExtraSmall,
                backgroundColor: AppColors.white),
          ));
    }).toList();

    return results;
  }

  List<Widget> _renderHeightLineEntities() {
    List<Widget> results = <Widget>[];
    results = this.entities.map((entity) {
      var _x = entity.rect!.x;
      var _y = entity.rect!.y;
      var _w = entity.rect!.w;
      var _h = entity.rect!.h;

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
            '${entity.detectedClass ?? ''} ${((entity.confidenceInClass ?? 0) * 100).toStringAsFixed(0)}%',
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.regularTextStyle(
                color: Colors.red,
                fontSize: AppFontSizes.extraExtraSmall,
                backgroundColor: AppColors.white),
          ),
        ),
      );
    }).toList();
    return results;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> childes = [];
    switch (type) {
      case ModelType.YOLO:
      case ModelType.SSDMobileNet:
        childes = _renderHeightLineEntities();
        break;
      case ModelType.MobileNet:
        childes = _renderStringEntities();
        break;
      case ModelType.PoseNet:
        childes = _renderPoseNet();
        break;
      default:
        childes = [];
    }
    return Stack(
      children: childes,
    );
  }
}
