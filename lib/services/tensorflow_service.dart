import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

enum ModelType { YOLO, SSDMobileNet }

class TensorFlowService {
  ModelType _type = ModelType.YOLO;

  ModelType get type => _type;

  loadModel(ModelType type) async {
    _type = type;
    try {
      Tflite.close();
      String? res;
      switch (type) {
        case ModelType.YOLO:
          res = await Tflite.loadModel(
              model: 'assets/yolov2_tiny.tflite',
              labels: 'assets/yolov2_tiny.txt');
          break;
        case ModelType.SSDMobileNet:
        default:
          res = await Tflite.loadModel(
              model: 'assets/yolov2_tiny.tflite',
              labels: 'assets/yolov2_tiny.txt');
      }
      print('loadModel: $res');
    } on PlatformException {
      print('Failed to load model.');
    }
  }

  close() {
    Tflite.close();
  }


  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
    var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        model: "YOLO",
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 0,
        imageStd: 255.0,
        threshold: 0.2,
        numResultsPerClass: 1
    );
    print("recognitions: $recognitions");
    return recognitions;
  }

  Future<List<dynamic>?> runModelOnImage(File image) async {
    var recognitions = await Tflite.detectObjectOnImage(
      path: image.path,
      model: "YOLO",
      threshold: 0.3,
      imageMean: 0.0,
      imageStd: 127.5,
      numResultsPerClass: 1
    );
    return recognitions;
  }
}
