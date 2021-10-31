import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:real_gamers_critics/configs/size_config.dart';

import 'package:real_gamers_critics/blocs/analytics.dart';
import 'package:real_gamers_critics/blocs/application_search_controller.dart';

import 'package:real_gamers_critics/functions/format/time.dart';

import 'package:real_gamers_critics/models/applications.dart';

import 'package:real_gamers_critics/view/detail_page.dart';

class SearchPage extends StatelessWidget {
  final ApplicationsSearchController applicationsSearchController = Get.find();

  SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AnalyticsBloc.onSearch();
    applicationsSearchController.fetch();

    return GetBuilder<ApplicationsSearchController>(
      init: applicationsSearchController,
      builder: (appController) {
        if (appController.hasError) {
          return Center(child: Text("err".tr));
        }
        if (appController.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        List<ApplicationInfos>? _list = appController.get("ByReviews");

        // tmp
        if (_list == null) {
          return Center(
            child: Text("order option error".tr),
          );
        }

        if (_list.length == 0) {
          return Center(
            child: Text("no games".tr),
          );
        }

        return Container(
            padding: EdgeInsets.only(top: SizeConfig.defaultSize),
            child: ListView.builder(
              itemCount: _list.length,
              padding: EdgeInsets.only(bottom: SizeConfig.defaultSize * 9),
              itemBuilder: (context, index) => _itemBuilder(_list[index]),
            ));
      },
    );
  }
}

Widget _itemBuilder(ApplicationInfos _app) {
  return Align(
      child: GestureDetector(
          onTap: () {
            Get.to(() => DetailPage(app: _app));
          },
          child: SizedBox(
              width: SizeConfig.defaultSize * 40,
              child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.defaultSize * 2),
                  ),
                  child: Row(children: [
                    // icon
                    Container(
                      width: SizeConfig.defaultSize * 10,
                      margin: EdgeInsets.only(
                          top: SizeConfig.defaultSize * 2,
                          left: SizeConfig.defaultSize * 1,
                          right: SizeConfig.defaultSize * 2.5,
                          bottom: SizeConfig.defaultSize * 2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.defaultSize * 2.2)),
                      child: _app.icon != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.defaultSize),
                              child: CachedNetworkImage(
                                height: SizeConfig.defaultSize * 10,
                                imageUrl: "${_app.iconUrl}",
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.image_not_supported),
                              ))
                          : Icon(Icons.not_accessible),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: SizeConfig.defaultSize * 24,
                            margin: EdgeInsets.only(
                                right: SizeConfig.defaultSize * 0.5,
                                bottom: SizeConfig.defaultSize * 0.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: Text('${_app.appName}',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 2,
                                            fontWeight: FontWeight.bold))),
                              ],
                            )),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                "assets/svg/game.svg",
                                semanticsLabel: 'game logo',
                                alignment: Alignment.center,
                                width: SizeConfig.defaultSize * 2,
                              ),
                              Text(" ${_app.category}\n")
                            ]), // TODO: tr
                      ],
                    )
                  ])))));
}
