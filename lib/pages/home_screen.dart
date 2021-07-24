import 'package:flutter/material.dart';
import 'package:flutter_realtime_object_detection/app/app_resources.dart';
import 'package:flutter_realtime_object_detection/app/base/base_stateful.dart';
import 'package:flutter_realtime_object_detection/view_models/home_view_model.dart';
import 'package:flutter_realtime_object_detection/view_states/home_view_state.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends BaseStateful<HomeScreen, HomeViewModel> {


  @override
  Widget buildBodyWidget(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: viewModel,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: true,
              actions: [
                IconButton(
                    onPressed: () {
                      viewModel?.isLoading = true;
                    },
                    icon: Icon(AppIcons.linkOption, semanticLabel: 'Repo'))
              ],
              backgroundColor: AppColors.blue,
              title: Text(
                AppStrings.title,
                style: AppTextStyles.boldTextStyle(
                    color: AppColors.white, fontSize: AppFontSizes.large),
              ),
            ),
            body: Consumer<HomeViewModel>(builder: (build, provide, _) {
              return Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.4),
                      border: Border.all(color: AppColors.blue, width: 2)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(AppIcons.plus)],
                  ));
            })));
  }

  @override
  HomeViewModel createViewModal(BuildContext context) {
    return HomeViewModel(context);
  }
}
