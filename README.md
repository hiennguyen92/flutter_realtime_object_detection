# Flutter realtime object detection with Tensorflow Lite

Flutter realtime object detection with Tensorflow Lite

## Info

An app made with Flutter and TensorFlow Lite for realtime object detection using model YOLO, SSD, MobileNet, PoseNet.



## :star: Features

* Realtime object detection on the live camera
* Using Model: YOLOv2-Tiny, SSDMobileNet, MobileNet, PoseNet
* Save image has been detected
* MVVM architecture

  <br>

## 🚀&nbsp; Installation

1. Install Packages
```
camera: get the streaming image buffers
https://pub.dev/packages/camera
```
  * <a href='https://pub.dev/packages/camera'>https://pub.dev/packages/camera</a>
```
tflite: run model TensorFlow Lite
https://pub.dev/packages/tflite
```
  * <a href='https://pub.dev/packages/tflite'>https://pub.dev/packages/tflite</a>
```
provider: state management
https://pub.dev/packages/provider
```
  * <a href='https://pub.dev/packages/provider'>https://pub.dev/packages/provider</a>

  <br>
2. Configure Project

* Android
```
android/app/build.gradle

android {
    ...
    aaptOptions {
        noCompress 'tflite'
        noCompress 'lite'
    }
    ...
}


minSdkVersion 21
```
  <br>
3. Load model

```
loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/models/yolov2_tiny.tflite",  
        //ssd_mobilenet.tflite, mobilenet_v1.tflite, posenet_mv1_checkpoints.tflite
        labels: "assets/models/yolov2_tiny.txt",    
        //ssd_mobilenet.txt, mobilenet_v1.txt
        //numThreads: 1, // defaults to 1
        //isAsset: true, // defaults: true, set to false to load resources outside assets
        //useGpuDelegate: false // defaults: false, use GPU delegate
    );
  }
```
  <br>
4. Run model

For Realtime Camera
```
  //YOLOv2-Tiny
  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
     var recognitions = await Tflite.detectObjectOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          model: "YOLO",
          imageHeight: image.height,
          imageWidth: image.width,
          imageMean: 0,                 // defaults to 127.5
          imageStd: 255.0,              // defaults to 127.5
          threshold: 0.2,               // defaults to 0.1
          numResultsPerClass: 1,
        );   
    return recognitions;
  }

  //SSDMobileNet
  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
     var recognitions = await Tflite.detectObjectOnFrame(
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
    return recognitions;
  }

  //MobileNet
  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
     var recognitions = await Tflite.runModelOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
          numResults: 5
        );   
    return recognitions;
  }

  //PoseNet
  Future<List<dynamic>?> runModelOnFrame(CameraImage image) async {
     var recognitions = await Tflite.runPoseNetOnFrame(
          bytesList: image.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: image.height,
          imageWidth: image.width,
          numResults: 5
        );   
    return recognitions;
  }
```
For Image
```
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
```
```
Output format:

YOLO,SSDMobileNet
  [{
    detectedClass: "dog",
    confidenceInClass: 0.989,
    rect: {
        x: 0.0,
        y: 0.0,
        w: 100.0,
        h: 100.0
    }
  },...]

MobileNet
[{
    index: 0,
    label: "WithMask",
    confidence: 0.989
  },...]

PoseNet
[{
    score: 0.5,
    keypoints: {
        0: {
            x: 0.2,
            y: 0.12,
            part: nose,
            score: 0.803
        },
        1: {
            x: 0.2,
            y: 0.1,
            part: leftEye,
            score: 0.8666
        },
        ...
    }
  },...]

```
  <br>
5. Issue

```
* IOS
Downgrading TensorFlowLiteC to 2.2.0

Downgrade your TensorFlowLiteC in /ios/Podfile.lock to 2.2.0
run pod install in your /ios folder
```
  <br>
6. Source code

```
please checkout repo github
https://github.com/hiennguyen92/flutter_realtime_object_detection
```
  * <a href='https://github.com/hiennguyen92/flutter_realtime_object_detection'>https://github.com/hiennguyen92/flutter_realtime_object_detection</a>
## :bulb: Demo

1. Demo Illustration: https://www.youtube.com/watch?v=__i7PRmz5kY&ab_channel=HienNguyen
2. Image
<table>
  <tr>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/flutter_realtime_object_detection/main/images/image1.jpg" width="250"></td>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/flutter_realtime_object_detection/main/images/image2.jpg" width="250"></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/flutter_realtime_object_detection/main/images/image3.jpg" width="250"></td>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/flutter_realtime_object_detection/main/images/image4.jpg" width="250"></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/flutter_realtime_object_detection/main/images/image5.jpg" width="250"></td>
    <td><img src="https://raw.githubusercontent.com/hiennguyen92/flutter_realtime_object_detection/main/images/image6.jpg" width="250"></td>
  </tr>
 </table>

