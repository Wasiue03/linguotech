import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:linguotech/Screens/Translation_Screen/translate.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();

    if (googleSignInAccount == null) {
      // User canceled the sign-in process
      return;
    }

    await GoogleSignIn().signOut(); // Sign out before initiating a new sign-in

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    User? user = userCredential.user;

    print('Signed in with Google: ${user?.uid}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign-in with Google successful!'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => TranslationScreen(),
      ),
    );
  } catch (e) {
    print('Error signing in with Google: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sign-in with Google failed. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
