import 'package:flutter/material.dart';
import 'package:linguotech/Screens/Login/user_login.dart';
import 'package:linguotech/Screens/Register_Screen/user_register.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/Capture.PNG', // Replace with the path to your image asset
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 20),
          Image.asset(
            "assets/images/logo.png",
            width: 80,
            height: 80,
          ),

          SizedBox(
            height: 20,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Welcome to LinguoTech",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Spacer(), // Center text vertically
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: Text("Register"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignInScreen()));
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors
                        .orange, // Change the text color to blue (or any color you prefer)
                  ),
                  child: Text("Sign In"),
                ),
              ],
            ),
          ),
          SizedBox(
              height: 40), // Add space from the bottom to the "Sign In" text
        ],
      ),
    );
  }
}
