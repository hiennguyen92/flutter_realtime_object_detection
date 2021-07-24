import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/pages/home_screen.dart';
import 'package:flutter_realtime_object_detection/pages/splash_screen.dart';
import 'package:flutter_realtime_object_detection/view_models/home_view_model.dart';
import 'package:provider/provider.dart';

class AppRoute {
  static const splashScreen = '/splashScreen';
  static const homeScreen = '/homeScreen';

  static Route<Object>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case homeScreen:
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => ChangeNotifierProvider(
                create: (context) => HomeViewModel(context),
                builder: (_, __) => HomeScreen()));
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
