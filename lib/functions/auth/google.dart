import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:real_gamers_critics/blocs/applications.dart';

import 'package:real_gamers_critics/functions/api/comment.dart';

Future<UserCredential> signInWithGoogle() async {
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
  CommentApi.updatePlaytime(InstalledApplicationsBloc.apps);

  // Once signed in, return the UserCredential
  return _user;
}

Future<void> logOutWithGoogle() async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
}
