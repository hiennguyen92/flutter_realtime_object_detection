import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/base/base_view_model.dart';
import 'package:provider/provider.dart';

abstract class BaseStateful<T extends StatefulWidget, E extends BaseViewModel>
    extends State<T> with AutomaticKeepAliveClientMixin {
  E? viewModel;

  @override
  bool get wantKeepAlive => false;

  @mustCallSuper
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (mounted) {
        afterFirstBuild(context);
      }
    });
    viewModel = Provider.of<E>(context, listen: false);
  }

  @protected
  void afterFirstBuild(BuildContext context) {}

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }



  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (viewModel == null) {
      viewModel = Provider.of<E>(context, listen: false);
    }
    return bodyWidget(context);
  }

  @protected
  Widget bodyWidget(BuildContext context) {
    return buildBodyWidget(context);
  }

  Widget buildBodyWidget(BuildContext context);

  Widget loadingWidget() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child:
            Center(child: CircularProgressIndicator(color: Colors.blue)));
  }
}
