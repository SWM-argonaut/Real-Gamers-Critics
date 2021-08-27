import 'package:flutter/material.dart';

import 'package:soma_app_usage/view/app_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("핸드폰에 깔려있는 앱"),
      ),
      body: AppList(),
    ));
  }
}
