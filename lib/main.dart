import 'package:flutter/material.dart';
import 'package:linguotech/Components/Landing_page.dart';
import 'package:linguotech/Components/home_page.dart';
import 'package:linguotech/Screens/Login/user_login.dart';
import 'package:linguotech/Screens/Register_Screen/user_register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:linguotech/Screens/Translation_Screen/translate.dart';
import 'package:linguotech/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) =>
            SignInScreen(), // Replace SignInScreen with your initial screen
        '/translation': (context) => TranslationScreen(),
        '/login': (context) => SignInScreen(),
        '/signup': (context) => RegisterScreen(),
      },
    );
  }
}
