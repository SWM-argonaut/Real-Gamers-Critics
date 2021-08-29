import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:soma_app_usage/functions/auth/google.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "로그인",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.all(50),
          ),
          SignInButton(
            Buttons.Google,
            onPressed: () {
              signInWithGoogle().then((value) {
                print(value.user?.displayName);
              });
            },
          )
        ],
      )),
    );
  }
}
