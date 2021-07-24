import 'package:flutter/material.dart';

abstract class BaseViewModel<T> with ChangeNotifier {

  BuildContext _context;

  T _state;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  T get state => _state;

  set isLoading(bool isLoading) {
    if(_isLoading != isLoading){
      _isLoading = isLoading;
      this.notifyListeners();
    }
  }

  BaseViewModel(this._context, this._state);
}