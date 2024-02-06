import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:linguotech/Screens/Translation_Screen/translate.dart';
import 'package:linguotech/services/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    _loadSavedLoginInfo();
  }

  Future<void> _loadSavedLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      saveLoginInfo = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  Future<void> _saveLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('password', _passwordController.text);
  }

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

        if (saveLoginInfo) {
          await _saveLoginInfo();
        }

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
                GestureDetector(
                  onTap: () {
                    // Trigger saving login info when the email field is tapped
                    if (saveLoginInfo) {
                      _saveLoginInfo();
                    }
                  },
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
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
                          if (saveLoginInfo) {
                            _saveLoginInfo();
                          }
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
                SizedBox(
                    height: 10), // Add some spacing between Log In and Sign Up

                TextButton(
                  onPressed: () {
                    // Navigate to the Sign Up screen when Sign Up is pressed
                    Navigator.pushNamed(context, '/signup');
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleForgotPassword() async {
    try {
      String email = _emailController.text.trim();

      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);

        // Show success message using SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password reset email sent. Check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show an error message for missing email
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please enter your email address.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error sending password reset email: $e');
      // Handle specific errors, such as invalid email or user not found.
      // Show an error message using SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending password reset email.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
