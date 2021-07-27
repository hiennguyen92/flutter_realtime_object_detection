
import 'package:flutter_realtime_object_detection/services/tensorflow_service.dart';

import '/models/recognition.dart';

class HomeViewState {

  ModelType type = ModelType.YOLO;

  late List<Recognition> recognitions = <Recognition>[];

  int widthImage = 0;

  int heightImage = 0;


  int cameraIndex = 0;

  bool isFrontCamera() {
    return cameraIndex == 1;
  }

  bool isBackCamera() {
    return cameraIndex == 0;
  }
  
}