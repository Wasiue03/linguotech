import 'package:flutter/material.dart';
import 'package:linguotech/Components/Landing_page.dart';
import 'package:linguotech/Components/home_page.dart';
import 'package:linguotech/Screens/Login/user_login.dart';
import 'package:linguotech/Screens/Register_Screen/user_register.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}
