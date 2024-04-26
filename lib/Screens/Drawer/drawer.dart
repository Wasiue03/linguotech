import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linguotech/Screens/Login/user_login.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: SvgPicture.asset(
              "assets/svg/translate.svg", // Path to your SVG image
              width: 100,
              height: 100,
            ),
          ),
          ListTile(
            title: Text('Feedback'),
            onTap: () {
              // Add your feedback functionality here
              Navigator.pop(context); // Close the drawer
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              // Add your logout functionality here
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SignInScreen()), // Replace LoginScreen with your actual login screen widget
              ); // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
