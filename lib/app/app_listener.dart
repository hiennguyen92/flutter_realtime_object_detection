
import 'dart:async';

class AppListener {
  static StreamController<Map> _appManageListener = StreamController.broadcast();

  static Map<Function, StreamSubscription> listeners = {};

  static void addListener(void onFunc(dynamic data)) {
    listeners[onFunc] = _appManageListener.stream.listen(onFunc);
  }

  static void removeListener(void onFunc(dynamic data)) {
    StreamSubscription? listener = listeners[onFunc];
    if(listener == null) return;
    listener.cancel();
    listeners.remove(onFunc);
  }

  static void close() {
    _appManageListener.close();
  }



  ///
  //登录成功广播
  static void test(dynamic data){
    _appManageListener.add(data);
  }

}