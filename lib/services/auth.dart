import 'package:apprecycle/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:apprecycle/pages/home.dart';
import 'package:apprecycle/services/shared_preference.dart';
import 'package:apprecycle/pages/bottomnav.dart';
import 'package:apprecycle/pages/points.dart';

class AuthMethods{

  Future<User?> signInWithGoogle(BuildContext context) async {

    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Google account select karna
    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();



    // Authentication tokens lena
    final GoogleSignInAuthentication? googleSignInAuthentication =
    await googleSignInAccount?.authentication;

    // Firebase credential banana
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    // Firebase me login karna
    UserCredential result =
    await firebaseAuth.signInWithCredential(credential);

    // Logged in user details
    User? userDetails = result.user;

    if (userDetails != null) {
      Map<String, dynamic> userInfoMap={
        "email":userDetails.email,
        "name": userDetails.displayName,
        "image": userDetails.photoURL,
        "id": userDetails.uid,
        "Points": 0
      };
      await DatabaseMethod().addUserInfo(userInfoMap, userDetails.uid);


      await SharedPreferenceHelper().saveUserId(userDetails.uid);
      await SharedPreferenceHelper().saveUserName(userDetails.displayName ?? "");
      await SharedPreferenceHelper().saveUserEmail(userDetails.email ?? "");
      await SharedPreferenceHelper().saveUserImage(userDetails.photoURL ?? "");

      print("✅ SAVED USER ID: ${userDetails.uid}");

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> BottomNav()));
    }

    return null;
  }
}