import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:linguotech/Screens/Translation_Screen/translate.dart';
// Replace with the actual import path

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // If successful, navigate to the TranslationScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TranslationScreen(),
      ),
    );

    // You can also print some information if needed
    print('Signed in with Google: ${userCredential.user?.uid}');
  } catch (e) {
    print('Error signing in with Google: $e');
    // Handle error (show a message, etc.)
    throw e; // Rethrow the error for the UI to handle
  }
}
