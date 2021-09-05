import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:soma_app_usage/configs/configs.dart'
    show playtimeToLeaveComment;
import 'package:soma_app_usage/configs/size_config.dart';

import 'package:soma_app_usage/blocs/applications.dart'
    show InstalledApplicationsBloc;

import 'package:soma_app_usage/models/applications.dart';

import 'package:soma_app_usage/widget/indicator.dart';

class AppList extends StatelessWidget {
  const AppList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: InstalledApplicationsBloc.isInit,
      builder: (BuildContext context, AsyncSnapshot<bool> data) {
        if (!data.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (data.hasError) {
          return Center(child: Text("err".tr));
        }

        return ListView.builder(
          itemCount: InstalledApplicationsBloc.apps.length,
          itemBuilder: _listItemBuilder,
        );
      },
    );
  }
}

Widget _listItemBuilder(BuildContext context, int index) {
  var _app = InstalledApplicationsBloc.apps[index];

  return Align(
      child: SizedBox(
          width: SizeConfig.defaultSize * 40,
          child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 2),
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
                      borderRadius:
                          BorderRadius.circular(SizeConfig.defaultSize * 1)),
                  child: _app.icon != null
                      ? Image(
                          image: MemoryImage(_app.icon!),
                        )
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
                            Text('${_app.appName}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: SizeConfig.defaultSize * 2,
                                    fontWeight: FontWeight.bold)),
                            ActionChip(
                              onPressed: () {},
                              label: Text('play'.tr,
                                  style: TextStyle(
                                      color: Color.fromRGBO(102, 48, 255, 1))),
                              backgroundColor: Color.fromRGBO(240, 235, 255, 1),
                            ),
                          ],
                        )),
                    Text("Play Time : ${_app.usage}\n"), // TODO: tr
                    LinearIndicator(
                      width: SizeConfig.defaultSize * 24,
                      percent: _app.usage!.inMinutes / playtimeToLeaveComment,
                      text:
                          "${_app.usage!.inMinutes}m/${playtimeToLeaveComment}m",
                    ),
                  ],
                )
              ]))));
}
