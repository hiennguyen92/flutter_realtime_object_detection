import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/app_resources.dart';
import 'package:flutter_realtime_object_detection/app/base/base_stateful.dart';
import 'package:flutter_realtime_object_detection/main.dart';
import 'package:flutter_realtime_object_detection/services/tensorflow_service.dart';
import 'package:flutter_realtime_object_detection/view_models/home_view_model.dart';
import 'package:flutter_realtime_object_detection/widgets/aperture/aperture_widget.dart';
import 'package:flutter_realtime_object_detection/widgets/confidence_widget.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends BaseStateful<HomeScreen, HomeViewModel>
    with WidgetsBindingObserver {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;


  @override
  bool get wantKeepAlive => true;

  @override
  void afterFirstBuild(BuildContext context) {
    super.afterFirstBuild(context);
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void initState() {
    super.initState();
    loadModel(ModelType.YOLO);
    initCamera();
  }

  void initCamera() {
    _cameraController = CameraController(
        cameras[viewModel.state.cameraIndex], ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }

      /// TODO: Run Model
      setState(() {});
      _cameraController.startImageStream((image) async {
        await viewModel.runModel(image);
      });
    });
  }

  void loadModel(ModelType type) async {
    await viewModel.loadModel(type);
  }

  Future<void> runModel(CameraImage image) async {
    if (mounted) {
      await viewModel.runModel(image);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    viewModel.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    /// TODO: Check Camera
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else {
      initCamera();
    }
  }

  @override
  Widget buildPageWidget(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: buildAppBarWidget(context),
      body: buildBodyWidget(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        viewModel.state.isBackCamera() ? Icons.camera_front : Icons.camera_rear,
        color: AppColors.blue,
      ),
      tooltip: "Switch Camera",
      backgroundColor: AppColors.white,
      onPressed: handleSwitchCameraClick,
    );
  }

  handleSwitchCameraClick() {
    viewModel.switchCamera();
    initCamera();
  }

  handleSwitchSource(ModelType item) {
    loadModel(item);
    initCamera();
  }

  @override
  AppBar buildAppBarWidget(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(AppIcons.linkOption, semanticLabel: 'Repo')),
        PopupMenuButton<ModelType>(
            onSelected: (item) => handleSwitchSource(item),
            color: AppColors.white,
            itemBuilder: (context) => [
                  PopupMenuItem(
                      enabled: !viewModel.state.isYolo(),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.api,
                              color: !viewModel.state.isYolo()
                                  ? AppColors.black
                                  : AppColors.grey),
                          Text(' YOLO',
                              style: AppTextStyles.regularTextStyle(
                                  color: !viewModel.state.isYolo()
                                      ? AppColors.black
                                      : AppColors.grey)),
                        ],
                      ),
                      value: ModelType.YOLO),
                  PopupMenuItem(
                      enabled: !viewModel.state.isSSDMobileNet(),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.api,
                              color: !viewModel.state.isSSDMobileNet()
                                  ? AppColors.black
                                  : AppColors.grey),
                          Text(' SSD MobileNet',
                              style: AppTextStyles.regularTextStyle(
                                  color: !viewModel.state.isSSDMobileNet()
                                      ? AppColors.black
                                      : AppColors.grey)),
                        ],
                      ),
                      value: ModelType.SSDMobileNet),
                  PopupMenuItem(
                      enabled: !viewModel.state.isMobileNet(),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.api,
                              color: !viewModel.state.isMobileNet()
                                  ? AppColors.black
                                  : AppColors.grey),
                          Text(' MobileNet',
                              style: AppTextStyles.regularTextStyle(
                                  color: !viewModel.state.isMobileNet()
                                      ? AppColors.black
                                      : AppColors.grey)),
                        ],
                      ),
                      value: ModelType.MobileNet),
                  PopupMenuItem(
                      enabled: !viewModel.state.isPoseNet(),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.api,
                              color: !viewModel.state.isPoseNet()
                                  ? AppColors.black
                                  : AppColors.grey),
                          Text(' PoseNet',
                              style: AppTextStyles.regularTextStyle(
                                  color: !viewModel.state.isPoseNet()
                                      ? AppColors.black
                                      : AppColors.grey)),
                        ],
                      ),
                      value: ModelType.PoseNet),
                ]),
      ],
      backgroundColor: AppColors.blue,
      title: Text(
        AppStrings.title,
        style: AppTextStyles.boldTextStyle(
            color: AppColors.white, fontSize: AppFontSizes.large),
      ),
    );
  }

  @override
  Widget buildBodyWidget(BuildContext context) {
    double heightAppBar = AppBar().preferredSize.height;

    return Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.4),
            border: Border.all(color: AppColors.blue, width: 2)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final Size screen = MediaQuery.of(context).size;
                      final double screenHeight =
                          max(screen.height, screen.width);
                      final double screenWidth =
                          min(screen.height, screen.width);
                      final Size previewSize =
                          _cameraController.value.previewSize!;
                      final double previewHeight =
                          max(previewSize.height, previewSize.width);
                      final double previewWidth =
                          min(previewSize.height, previewSize.width);
                      final double screenRatio = screenHeight / screenWidth;
                      final double previewRatio = previewHeight / previewWidth;
                      return Stack(
                        children: <Widget>[
                          OverflowBox(
                            maxHeight: screenRatio > previewRatio
                                ? screenHeight
                                : screenWidth / previewWidth * previewHeight,
                            maxWidth: screenRatio > previewRatio
                                ? screenHeight / previewHeight * previewWidth
                                : screenWidth,

                            child: CameraPreview(_cameraController),
                          ),
                          Consumer<HomeViewModel>(
                              builder: (_, homeViewModel, __) {
                            return ConfidenceWidget(
                              heightAppBar: heightAppBar,
                              entities: homeViewModel.state.recognitions,
                              previewHeight: max(
                                  homeViewModel.state.heightImage,
                                  homeViewModel.state.widthImage),
                              previewWidth: min(homeViewModel.state.heightImage,
                                  homeViewModel.state.widthImage),
                              screenWidth: MediaQuery.of(context).size.width,
                              screenHeight: MediaQuery.of(context).size.height,
                              type: homeViewModel.state.type,
                            );
                          }),
                          ApertureWidget(
                            controller: ApertureWidgetController
                          )
                        ],
                      );
                    } else {
                      return const Center(
                          child:
                              CircularProgressIndicator(color: AppColors.blue));
                    }
                  })),
        ));
  }
}

