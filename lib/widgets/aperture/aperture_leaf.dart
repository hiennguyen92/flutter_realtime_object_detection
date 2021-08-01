import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/widgets/aperture/aperture_leaf_painter.dart';

class ApertureLeaf extends StatefulWidget {
  final double borderWidth;
  final AnimationController? animationController;
  final Animation<double>? curvedAnimation;
  final bool startOpened;

  final double parentWidth;

  final Widget? child;

  final bool isShowChild;

  ApertureLeaf(
      {required this.borderWidth,
      required this.parentWidth,
      this.animationController,
      this.curvedAnimation,
      this.child,
      this.isShowChild = false,
      this.startOpened = true});

  @override
  State<StatefulWidget> createState() {
    return _ApertureLeafState();
  }
}

class _ApertureLeafState extends State<ApertureLeaf>
    with SingleTickerProviderStateMixin {
  static const apertureBorderWidth = 2.0;
  static const open1 = 0.78;
  static const open2 = 0.33;

  late AnimationController animationController;
  late Animation<double> curvedAnimation;

  late Animation<Offset> _slide1;
  late Animation<Offset> _slide2;
  late Animation<Offset> _slide3;
  late Animation<Offset> _slide4;
  late Animation<Offset> _slide5;
  late Animation<Offset> _slide6;

  @override
  void initState() {
    super.initState();
    animationController = (widget.animationController != null
        ? widget.animationController
        : AnimationController(
            vsync: this, duration: Duration(milliseconds: 500)))!;

    curvedAnimation = (widget.curvedAnimation != null
        ? widget.curvedAnimation
        : CurvedAnimation(
            parent: animationController, curve: Curves.easeInOutBack))!;

    _slide1 = widget.startOpened
        ? Tween(begin: Offset(open1, 0.0), end: Offset(0.0, 0.0))
            .animate(curvedAnimation)
        : Tween(begin: Offset(0.0, 0.0), end: Offset(open1, 0.0))
            .animate(curvedAnimation);
    _slide2 = widget.startOpened
        ? Tween(begin: Offset(open2, open1), end: Offset(0.0, 0.0))
            .animate(curvedAnimation)
        : Tween(begin: Offset(0.0, 0.0), end: Offset(open2, open1))
            .animate(curvedAnimation);
    _slide3 = widget.startOpened
        ? Tween(begin: Offset(-open2, open1), end: Offset(0.0, 0.0))
            .animate(curvedAnimation)
        : Tween(begin: Offset(0.0, 0.0), end: Offset(-open2, open1))
            .animate(curvedAnimation);
    _slide4 = widget.startOpened
        ? Tween(begin: Offset(-open1, 0.0), end: Offset(0.0, 0.0))
            .animate(curvedAnimation)
        : Tween(begin: Offset(0.0, 0.0), end: Offset(-open1, 0.0))
            .animate(curvedAnimation);
    _slide5 = widget.startOpened
        ? Tween(begin: Offset(-open2, -open1), end: Offset(0.0, 0.0))
            .animate(curvedAnimation)
        : Tween(begin: Offset(0.0, 0.0), end: Offset(-open2, -open1))
            .animate(curvedAnimation);
    _slide6 = widget.startOpened
        ? Tween(begin: Offset(open2, -open1), end: Offset(0.0, 0.0))
            .animate(curvedAnimation)
        : Tween(begin: Offset(0.0, 0.0), end: Offset(open2, -open1))
            .animate(curvedAnimation);

    if (widget.animationController == null) {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double boxWidth = widget.parentWidth;
    final bladeHeight = sqrt((pow(boxWidth, 2) - pow((boxWidth / 2), 2)));
    final heightDelta = boxWidth - bladeHeight;

    return LayoutBuilder(builder: (context, constraints) {
      final centerX = constraints.maxWidth / 2;
      final centerY = constraints.maxHeight / 2;

      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (widget.child != null && widget.isShowChild)
            Container(
              alignment: Alignment.center,
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              child: widget.child,
            ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 0)),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                    left: centerX + (boxWidth / 2),
                    top: centerY + heightDelta,
                    child: AnimatedBuilder(
                      builder: (context, child) =>
                          SlideTransition(position: _slide1, child: child),
                      animation: animationController,
                      child: FittedBox(
                          fit: BoxFit.none,
                          child: SizedBox(
                              width: boxWidth,
                              height: boxWidth,
                              child: CustomPaint(
                                painter: ApertureLeafPainter(
                                    borderWidth: widget.borderWidth,
                                    rotationRadians: pi,
                                    fillColor: Colors.grey.shade900),
                              ))),
                    )),
                Positioned(
                    left: centerX - apertureBorderWidth,
                    top: centerY -
                        (boxWidth - bladeHeight) -
                        bladeHeight +
                        (apertureBorderWidth / 2),
                    child: AnimatedBuilder(
                      builder: (context, child) =>
                          SlideTransition(position: _slide2, child: child),
                      animation: animationController,
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: SizedBox(
                            width: boxWidth,
                            height: boxWidth,
                            child: CustomPaint(
                              painter: ApertureLeafPainter(
                                  borderWidth: widget.borderWidth,
                                  rotationRadians: 0,
                                  fillColor: Colors.grey.shade900),
                            )),
                      ),
                    )),
                Positioned(
                    left: centerX + boxWidth - apertureBorderWidth,
                    top: centerY + heightDelta + bladeHeight,
                    child: AnimatedBuilder(
                      builder: (context, child) =>
                          SlideTransition(position: _slide3, child: child),
                      animation: animationController,
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: SizedBox(
                            width: boxWidth,
                            height: boxWidth,
                            child: CustomPaint(
                              painter: ApertureLeafPainter(
                                  borderWidth: widget.borderWidth,
                                  rotationRadians: pi,
                                  fillColor: Colors.grey.shade900),
                            )),
                      ),
                    )),
                Positioned(
                    left: centerX - (boxWidth * 0.5),
                    top: centerY - heightDelta,
                    child: AnimatedBuilder(
                      builder: (context, child) =>
                          SlideTransition(position: _slide4, child: child),
                      animation: animationController,
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: SizedBox(
                            width: boxWidth,
                            height: boxWidth,
                            child: CustomPaint(
                              painter: ApertureLeafPainter(
                                  borderWidth: widget.borderWidth,
                                  rotationRadians: 0,
                                  fillColor: Colors.grey.shade900),
                            )),
                      ),
                    )),
                Positioned(
                    left: centerX + apertureBorderWidth,
                    top: centerY + heightDelta + bladeHeight,
                    child: AnimatedBuilder(
                      builder: (context, child) =>
                          SlideTransition(position: _slide5, child: child),
                      animation: animationController,
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: SizedBox(
                            width: boxWidth,
                            height: boxWidth,
                            child: CustomPaint(
                              painter: ApertureLeafPainter(
                                  borderWidth: widget.borderWidth,
                                  rotationRadians: pi,
                                  fillColor: Colors.grey.shade900),
                            )),
                      ),
                    )),
                Positioned(
                    left: centerX - boxWidth + apertureBorderWidth,
                    top: centerY -
                        heightDelta -
                        bladeHeight +
                        (apertureBorderWidth / 2),
                    child: AnimatedBuilder(
                      builder: (context, child) =>
                          SlideTransition(position: _slide6, child: child),
                      animation: animationController,
                      child: FittedBox(
                        fit: BoxFit.none,
                        child: SizedBox(
                            width: boxWidth,
                            height: boxWidth,
                            child: CustomPaint(
                              painter: ApertureLeafPainter(
                                  borderWidth: widget.borderWidth,
                                  rotationRadians: 0,
                                  fillColor: Colors.grey.shade900),
                            )),
                      ),
                    ))
              ],
            ),
          ),
        ],
      );
    });
  }
}
