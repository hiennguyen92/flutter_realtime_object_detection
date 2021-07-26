import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/base/base_view_model.dart';
import 'package:flutter_realtime_object_detection/services/tensorflow_service.dart';
import 'package:flutter_realtime_object_detection/view_states/local_view_state.dart';

class LocalViewModel extends BaseViewModel<LocalViewState> {

  bool _isLoadModel = false;

  late TensorFlowService _tensorFlowService;


  LocalViewModel(BuildContext context, this._tensorFlowService) : super(context, LocalViewState());


  Future<void> loadModel(ModelType type) async {
    await this._tensorFlowService.loadModel(type);
    this._isLoadModel = true;
  }

  Future<void> runModel(File file) async {
    if(_isLoadModel) {
      var recognitions = await this._tensorFlowService.runModelOnImage(file);
      if (recognitions != null) {
        state.recognitions = recognitions;
        print('recognitions ${recognitions.toString()}');
        notifyListeners();
      }
    }else{
      throw 'Please run `loadModel(type)` before running `runModelOnImage(file)`';
    }
  }

  void close() {
    this._tensorFlowService.close();
  }



  Future updateImageSelected(File file) async {
    state.imageSelected = file;
    this.notifyListeners();
  }

  bool isHasPicked() {
    return state.imageSelected != null;
  }

  String getTextDetected() {
    return state.getTextDetected();
  }



}