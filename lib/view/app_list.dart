import 'package:flutter/material.dart';

import 'package:soma_app_usage/blocs/applications.dart'
    show InstalledApplicationsBloc;
import 'package:soma_app_usage/models/applications.dart';

class AppList extends StatefulWidget {
  const AppList({Key? key}) : super(key: key);

  @override
  _AppListState createState() => _AppListState();
}

class _AppListState extends State<AppList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: InstalledApplicationsBloc.isInit,
      builder: (BuildContext context, AsyncSnapshot<bool> data) {
        if (!data.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        if (data.hasError) {
          return Center(child: Text("뭔가 잘못됨..."));
        }

        return ListView.builder(
            itemCount: InstalledApplicationsBloc.apps.length,
            itemBuilder: (BuildContext context, int index) {
              var _app = InstalledApplicationsBloc.apps[index];
              return ListTile(
                leading: _app.icon != null
                    ? Image(
                        image: MemoryImage(_app.icon!),
                      )
                    : Icon(Icons.not_accessible),
                title: Text('${_app.appName} (${_app.packageName})'),
                subtitle: Text(''
                    '버전: ${_app.versionName}\n'
                    '사용시간 : ${_app.usage?.inMinutes}분\n'
                    '카테고리 : ${_app.category}\n'
                    '시스템 앱 여부: ${_app.systemApp}\n'
                    'APK 파일 위치: ${_app.apkFilePath}\n'
                    '디렉토리: ${_app.dataDir}\n'
                    '설치된 날: ${DateTime.fromMillisecondsSinceEpoch(_app.installTimeMillis)}\n'
                    '업데이트된 날: ${DateTime.fromMillisecondsSinceEpoch(_app.updateTimeMillis)}'),
              );
            });
      },
    );
  }
}
