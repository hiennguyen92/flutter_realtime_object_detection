import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/app_resources.dart';
import 'package:flutter_realtime_object_detection/app/base/base_stateful.dart';
import 'package:flutter_realtime_object_detection/services/tensorflow_service.dart';
import 'package:flutter_realtime_object_detection/view_models/local_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LocalScreenState();
  }
}

class _LocalScreenState extends BaseStateful<LocalScreen, LocalViewModel> {
  ImagePicker _imagePicker = ImagePicker();

  double _imageHeight = 0;
  double _imageWidth = 0;

  @override
  void afterFirstBuild(BuildContext context) {
    super.afterFirstBuild(context);
  }

  @override
  void initState() {
    super.initState();
    loadModel(ModelType.YOLO);
  }

  void loadModel(ModelType type) async {
    await viewModel.loadModel(type);
  }

  void runModel(File image) async {
    if (mounted) {
      await viewModel.runModel(image);
      viewModel.isLoading = false;
    }
  }

  selectImage() async {
    viewModel.isLoading = true;
    XFile? _imageFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_imageFile == null) {
      viewModel.isLoading = false;
      return;
    }
    viewModel.updateImageSelected(File(_imageFile.path));


    new FileImage(viewModel.state.imageSelected!)
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      setState(() {
        _imageHeight = info.image.height.toDouble();
        _imageWidth = info.image.width.toDouble();
      });
    }));


    runModel(viewModel.state.imageSelected!);
  }

  _gotoRepo() async {
    if (await canLaunch(AppStrings.urlRepo)) {
      await launch(AppStrings.urlRepo);
    } else {}
  }

  @override
  AppBar buildAppBarWidget(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              _gotoRepo();
            },
            icon: Icon(AppIcons.linkOption, semanticLabel: 'Repo'))
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
  Widget buildPageWidget(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        appBar: buildAppBarWidget(context),
        body: buildBodyWidget(context),
        floatingActionButton: buildFloatingActionButton(context)
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        AppIcons.plus,
        color: AppColors.blue,
      ),
      tooltip: "Pick From Gallery",
      backgroundColor: AppColors.white,
      onPressed: selectImage,
    );
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.close();
  }

  @override
  Widget buildBodyWidget(BuildContext context) {
    return Consumer<LocalViewModel>(builder: (build, provide, _) {
      return viewModel.isLoading ? loadingWidget() : contentWidget();
    });
  }


  List<Widget> renderBoxes(Size screen) {
    if (_imageHeight == 0 || _imageWidth == 0) return [];

    double factorX = screen.width;
    double factorY = _imageHeight / _imageWidth * screen.width;
    Color blue = Color.fromRGBO(37, 213, 253, 1.0);
    return viewModel.state.recognitions.map((re) {
      return Positioned(
        left: re["rect"]["x"] * factorX,
        top: re["rect"]["y"] * factorY,
        width: re["rect"]["w"] * factorX,
        height: re["rect"]["h"] * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
              color: blue,
              width: 2,
            ),
          ),
          child: Text(
            "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = blue,
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget contentWidget() {
    List<Widget> stackChildren = renderBoxes(MediaQuery.of(context).size);

    return Container(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.blue.withOpacity(0.4),
          border: Border.all(color: AppColors.blue, width: 2)),
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
                top: 0.0,
                left: 0.0,
                width: MediaQuery.of(context).size.width,
                child: Image.file(viewModel.state.imageSelected!)),
            ...stackChildren
          ],
        )
      ),
    );
  }
}
