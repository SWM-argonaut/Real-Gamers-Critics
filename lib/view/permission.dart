import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:real_gamers_critics/blocs/applications.dart';

import 'package:real_gamers_critics/view/home.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("need access".tr),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("need access to get playtime".tr),
          ElevatedButton(
              onPressed: () {
                InstalledApplicationsBloc.init();
                Get.offAll(() => Home());
              },
              child: Text("reload".tr))
        ]),
      ),
    );
  }
}
