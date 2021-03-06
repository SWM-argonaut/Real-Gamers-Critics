import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:provider/provider.dart';

import 'package:real_gamers_critics/configs/configs.dart';
import 'package:real_gamers_critics/configs/languages.dart' as Ln;

import 'package:real_gamers_critics/blocs/init.dart';
import 'package:real_gamers_critics/blocs/providers/comment_provicer.dart';

import 'package:real_gamers_critics/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CommentProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: initialization(),
      builder: (context, snapshot) {
        // Check for errors TODO
        if (snapshot.hasError) {
          return Center(child: Text("Firebase Error".tr));
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
              // translations
              locale: Get.deviceLocale,
              fallbackLocale: Locale('en', 'US'),
              translations: Ln.Messages(),

              // theme
              theme: ThemeData(
                primaryColor: Colors.white,
                backgroundColor: Colors.white,
                canvasColor: backgroundColor,
                appBarTheme: AppBarTheme(elevation: 0, color: backgroundColor),
              ),

              // home
              home: Home());
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
