import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_signin_button/flutter_signin_button.dart';

import 'package:real_gamers_critics/functions/auth/google.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    // log("${FirebaseAuth.instance.currentUser}");

    if (FirebaseAuth.instance.currentUser == null) {
      return _loginPage();
    }

    return _logoutPage();
  }

  Scaffold _loginPage() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("로그인"),
      ),
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
                setState(() {
                  print(value.user?.displayName);
                });
              });
            },
          )
        ],
      )),
    );
  }

  Scaffold _logoutPage() {
    () async {
      log("${await FirebaseAuth.instance.currentUser?.getIdToken()}");
    }();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("로그인"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "${FirebaseAuth.instance.currentUser?.photoURL}"),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
            ),
            Text(
              "이름 : ${FirebaseAuth.instance.currentUser?.displayName}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "이메일 : ${FirebaseAuth.instance.currentUser?.email}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            ElevatedButton(
              child: Text("로그아웃"),
              onPressed: () {
                logOutWithGoogle().then((_) {
                  setState(() {});
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
