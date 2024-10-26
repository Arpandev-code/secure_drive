import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  var isSignedIn = false.obs;
  final box = GetStorage();

  @override
  void onInit() {
    getUid();
    super.onInit();
  }

  //!>>>>>>>>>>>>>>>>>>>>>>Get UID for Local
  getUid() async {
    String uid = await box.read("uid");

    if (uid.isEmpty) {
      isSignedIn.value = false;
    } else {
      isSignedIn.value = true;
    }
  }

  //!>>>>>>>>>>>>>>>>>>>>>>Login
  login() async {
    try {
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

    if (userCredential.user != null) {
      //---------------Save Data to Local Storge for First Time Login---------------
      await box.write("uid", userCredential.user!.uid);

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      users.doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'name': userCredential.user!.displayName,
        'email': userCredential.user!.email,
        'photoUrl': userCredential.user!.photoURL,
      });
      isSignedIn(true);
    }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  //!>>>>>>>>>>>>>>>>>>>>>>Logout
  logout() async {
    try {
       debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>logout");
    await box.remove("uid");
    await GoogleSignIn().signOut();
    isSignedIn(false);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
   
  }
}
