import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_realtime_object_detection/app/app_router.dart';
import 'package:flutter_realtime_object_detection/services/navigation_service.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(seconds: 5), () {
        Provider.of<NavigationService>(context, listen: false).pushNamedAndRemoveUntil(AppRoute.homeScreen);
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => HomeScreen()), (_) => false);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFFC5C7D), Color(0xFF6A82FB)],
          stops: [0.1, 0.9]
        )
      ),
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
    );
  }
}