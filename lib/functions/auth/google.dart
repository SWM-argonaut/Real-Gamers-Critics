import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:get/get.dart';

import 'package:real_gamers_critics/blocs/myCommentsController.dart';
import 'package:real_gamers_critics/blocs/applicationsController.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';

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
  CommentApi.updatePlaytime();

  // get my comments
  _myComments.load();

  // Once signed in, return the UserCredential
  return _user;
}

Future<void> logOutWithGoogle() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}
