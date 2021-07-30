import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/widgets/aperture/aperture_leaf.dart';



class ApertureWidget extends StatefulWidget {



  const ApertureWidget(
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ApertureWidgetState();
  }
}

class _ApertureWidgetState extends State<ApertureWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 1000), () {
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
