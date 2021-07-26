import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/base/base_view_model.dart';
import 'package:flutter_realtime_object_detection/services/tensorflow_service.dart';
import 'package:flutter_realtime_object_detection/view_states/home_view_state.dart';

class HomeViewModel extends BaseViewModel<HomeViewState> {

  bool _isLoadModel = false;

  TensorFlowService _tensorFlowService;


  HomeViewModel(BuildContext context, this._tensorFlowService) : super(context, HomeViewState());

  void increase() {
    state.counter++;
    notifyListeners();
  }


  Future<void> loadModel(ModelType type) async {
    await this._tensorFlowService.loadModel(type);
    this._isLoadModel = true;
  }

  Future<void> runModel(CameraImage cameraImage) async {
    if(_isLoadModel) {
      var recognitions = await this._tensorFlowService.runModelOnFrameTesting(cameraImage);
      if (recognitions != null) {
        state.recognitions = recognitions;
        print('recognitions ${recognitions.toString()}');
        notifyListeners();
      }
    }else{
      throw 'Please run `loadModel(type)` before running `runModel(cameraImage)`';
    }
  }

  void tensorFlowDispose() {
    this._tensorFlowService.dispose();
  }



}