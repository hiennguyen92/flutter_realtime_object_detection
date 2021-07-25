import 'dart:io';

import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

enum ModelType { YOLO, SSDMobileNet }

class TensorFlowService {
  ModelType _type = ModelType.YOLO;

  ModelType get type => _type;

  loadModel(ModelType type) async {
    _type = type;
    Tflite.close();
    switch (type) {
      case ModelType.YOLO:
        await Tflite.loadModel(
            model: 'assets/models/yolov2_tiny.tflite',
            labels: 'assets/models/yolov2_tiny.txt');
        break;
      case ModelType.SSDMobileNet:
      default:
        await Tflite.loadModel(
            model: 'assets/models/yolov2_tiny.tflite',
            labels: 'assets/models/yolov2_tiny.txt');
    }
  }

  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
    var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: image.planes.map((plane) {
          return plane.bytes;
        }).toList(),
        model: _type.toString(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 0,
        imageStd: 255.0,
        rotation: 90,
        threshold: 0.1,
        numResultsPerClass: 2,
        blockSize: 32,
        numBoxesPerBlock: 5,
        asynch: true);
    return recognitions;
  }

  Future<List<dynamic>?> runModelOnImage(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    return recognitions;
  }
}
