import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/widgets/aperture/aperture_leaf.dart';



class ApertureWidget extends StatefulWidget {

  final StreamController apertureController;

  final Widget? child;

  ApertureWidget({required this.apertureController, this.child});


  @override
  State<StatefulWidget> createState() {
    return _ApertureWidgetState();
  }
}

class _ApertureWidgetState extends State<ApertureWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = widget.apertureController.stream.asBroadcastStream().listen((event) {
      print(event);
      animationController.forward();
    });

    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 200), () {
          animationController.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        // Future.delayed(const Duration(milliseconds: 10000), () {
        //   animationController.forward();
        // });
      }
    });
    animationController.forward();
  }


  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: ApertureLeaf(
                parentWidth: MediaQuery.of(context).size.width + 100,
                animationController: animationController,
                borderWidth: 2.0,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
