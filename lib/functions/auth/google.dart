import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:real_gamers_critics/blocs/analytics.dart';

import 'package:real_gamers_critics/blocs/my_comments_controller.dart';
import 'package:real_gamers_critics/blocs/applications_controller.dart';

import 'package:real_gamers_critics/functions/api/playtime.dart';

Future<UserCredential> signInWithGoogle() async {
  MyCommentsController _myComments = Get.find();

  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth =
      await googleUser!.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  UserCredential _user =
      await FirebaseAuth.instance.signInWithCredential(credential);

  // update game playtime
  PlaytimeApi.updatePlaytime();

  // get my comments
  _myComments.load();

  AnalyticsBloc.onLogin();

  // one signal tag
  OneSignal.shared
      .sendTag("google uid", FirebaseAuth.instance.currentUser?.uid);

  // Once signed in, return the UserCredential
  return _user;
}

Future<void> logOutWithGoogle() async {
  MyCommentsController _myComments = Get.find();

  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
  AnalyticsBloc.onLogout();
  OneSignal.shared.deleteTag("google uid");
  _myComments.load();
}
