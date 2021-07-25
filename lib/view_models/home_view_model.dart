import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/base/base_view_model.dart';
import 'package:flutter_realtime_object_detection/view_states/home_view_state.dart';

class HomeViewModel extends BaseViewModel<HomeViewState> {

  bool _isLoadModel = false;


  HomeViewModel(BuildContext context) : super(context, HomeViewState());

  void increase() {
    state.counter++;
    notifyListeners();
  }


}