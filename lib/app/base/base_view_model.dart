import 'package:flutter/material.dart';

abstract class BaseViewModel<T> with ChangeNotifier {

  bool _mounted = true;

  BuildContext _context;

  T _state;

  bool get mounted => _mounted;

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

  @override
  void dispose() {
    super.dispose();
    _mounted = false;
  }
}