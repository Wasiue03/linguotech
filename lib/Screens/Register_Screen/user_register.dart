import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:linguotech/model/firebase_Auth.dart';
import 'package:linguotech/services/firebase_service.dart';

class RegisterScreen extends StatelessWidget {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  TextEditingController nameController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Future<void> _register(BuildContext context) async {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    // Validate if any field is empty
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar(context, 'Please fill in all fields');
      return;
    }

    if (e.toString().contains('email-already-in-use')) {
      _showSnackBar(
          context, 'Email already exists. Please use a different email.');
    } else {
      // Handle other registration failures
      _showSnackBar(context, 'Registration failed. Please try again.');
    }
    // Validate if the password is strong enough
    if (password.length < 6) {
      _showSnackBar(context, 'Password must be at least 6 characters');
      return;
    }

    try {
      User? user =
          await _authService.registerWithEmailAndPassword(email, password);

      if (user != null) {
        await _firestoreService.addUser(
          user.uid,
          name,
          professionController.text,
          email,
        );

        nameController.clear();
        emailController.clear();
        passwordController.clear();
        professionController.clear();

        // Registration successful, you can show a success message
        _showSnackBar(context, 'Registration successful');
      }
    } catch (e) {
      print("Error during registration: $e");
      // Handle registration failure (e.g., show an error message)
      _showSnackBar(context, 'Please fill in all fields');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: professionController,
              decoration: InputDecoration(
                labelText: 'Profession',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _register(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                backgroundColor: Colors.orange,
              ),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
