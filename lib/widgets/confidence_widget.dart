

import 'package:flutter/material.dart';

class ConfidenceWidget extends StatefulWidget {

  final List<dynamic> _entities;

  const ConfidenceWidget({required List<dynamic> entities}) : this._entities = entities;

  @override
  State<StatefulWidget> createState() {
    return _ConfidenceWidgetState();
  }
}

class _ConfidenceWidgetState extends State<ConfidenceWidget> {
  @override
  Widget build(BuildContext context) {
    print(widget._entities);
    return Container();
  }

}