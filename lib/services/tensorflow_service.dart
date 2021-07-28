import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

enum ModelType { YOLO, SSDMobileNet, MobileNet, PoseNet }

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
              model: 'assets/models/yolov2_tiny.tflite',
              labels: 'assets/models/yolov2_tiny.txt');
          break;
        case ModelType.SSDMobileNet:
          res = await Tflite.loadModel(
              model: 'assets/models/ssd_mobilenet.tflite',
              labels: 'assets/models/ssd_mobilenet.txt');
          break;
        case ModelType.MobileNet:
          res = await Tflite.loadModel(
              model: 'assets/models/mobilenet_v1.tflite',
              labels: 'assets/models/mobilenet_v1.txt');
          break;
        case ModelType.PoseNet:
          res = await Tflite.loadModel(
              model: 'assets/models/posenet_mv1_checkpoints.tflite');
          break;
        default:
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
    List<dynamic>? recognitions = <dynamic>[];
    switch (_type) {
      case ModelType.YOLO:
        recognitions = await Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          model: "YOLO",
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 0,
          imageStd: 255.0,
          threshold: 0.2,
          numResultsPerClass: 1,
        );
        break;
      case ModelType.SSDMobileNet:
        recognitions = await Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          model: "SSDMobileNet",
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 127.5,
          imageStd: 127.5,
          threshold: 0.4,
          numResultsPerClass: 1,
        );
        break;
      case ModelType.MobileNet:
        recognitions = await Tflite.runModelOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
          numResults: 2
        );
        break;
      case ModelType.PoseNet:
        recognitions = await Tflite.runPoseNetOnFrame(
            bytesList: image.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            imageHeight: image.height,
            imageWidth: image.width,
            numResults: 2
        );
        break;
    }
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
        numResultsPerClass: 1);
    return recognitions;
  }
}
