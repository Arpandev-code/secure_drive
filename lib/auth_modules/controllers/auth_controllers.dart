import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSignedIn = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<UserCredential> login() async {
    debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>login");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    debugPrint(
        ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>UserCredential: $userCredential");
    return userCredential;
  }
}
