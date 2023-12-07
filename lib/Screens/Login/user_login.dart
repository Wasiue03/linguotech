import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linguotech/Screens/Translation_Screen/translate.dart';
import 'package:linguotech/services/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool saveLoginInfo = false;
  bool _isPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text;

      if (email.isNotEmpty && password.isNotEmpty) {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        print('Signed in with email and password: ${user?.uid}');

        // Show success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-in successful!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                TranslationScreen(), // Replace HomeScreen with your actual home screen widget
          ),
        );

        // Navigate to the next screen or perform other actions after successful sign-in.
      } else {
        // Show an error message for missing email or password.
        print('Please enter email and password');
      }
    } catch (e) {
      print('Error signing in with email and password: $e');
      // Handle specific errors, such as invalid email or wrong password.
      // Show an error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed. Please check your credentials.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await signInWithGoogle(context);

      // If the authentication is successful, navigate to the TranslationScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TranslationScreen(),
        ),
      );
    } catch (e) {
      print('Error signing in with Google in UI: $e');
      // Handle error (show a message, etc.)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
                Row(
                  children: [
                    Checkbox(
                      value: saveLoginInfo,
                      onChanged: (value) {
                        setState(() {
                          saveLoginInfo = value!;
                        });
                      },
                    ),
                    Text(
                      'Save Login Info',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                if (saveLoginInfo)
                  Icon(
                    Icons.check,
                    color: Colors.green,
                  ),
                SizedBox(
                  height: 20,
                ),
                TextButton(
                  onPressed: _handleForgotPassword,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                      "-------------------------- OR ------------------------"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  onPressed: () => signInWithGoogle(context),
                  icon: Image.asset(
                    'assets/images/googleIcon.png', // Replace with your actual asset path
                    height: 24, // Adjust the height as needed
                  ),
                  label: Text(
                    'Sign In with Google',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _signInWithEmailAndPassword(context),
                  child: Text(
                    'Log In',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleForgotPassword() {}
}
