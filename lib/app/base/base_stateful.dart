import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/base/base_view_model.dart';
import 'package:provider/provider.dart';

abstract class BaseStateful<T extends StatefulWidget, E extends BaseViewModel>
    extends State<T> with AutomaticKeepAliveClientMixin {
  late E viewModel = Provider.of<E>(context, listen: false);

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
    return ChangeNotifierProvider.value(
        value: viewModel, child: buildPageWidget(context));
  }

  @protected
  Widget buildPageWidget(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarWidget(context),
      body: buildBodyWidget(context),
    );
  }

  @protected
  AppBar buildAppBarWidget(BuildContext context);

  @protected
  Widget buildBodyWidget(BuildContext context);

  Widget loadingWidget() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Center(child: CircularProgressIndicator(color: Colors.blue)));
  }
}
