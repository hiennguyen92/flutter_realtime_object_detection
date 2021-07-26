
import 'dart:io';

class LocalViewState {

  late List<dynamic> recognitions = <dynamic>[];

  File? imageSelected;


  String getTextDetected() {
    return (recognitions.isNotEmpty) ? recognitions[0]['detectedClass'] : '';
  }

}