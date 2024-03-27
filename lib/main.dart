// import 'package:flutter/material.dart';
// import 'package:linguotech/Screens/Login/user_login.dart';
// import 'package:linguotech/Screens/Register_Screen/user_register.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:linguotech/Screens/Summarization/summary.dart';
// import 'package:linguotech/Screens/Translation_Screen/translate.dart';
// import 'package:linguotech/Screens/settings/settings.dart';
// import 'package:linguotech/firebase_options.dart';
// import 'package:linguotech/services/theme_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SharedPreferences.getInstance();
//   getCurrentAppTheme();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {

//   const MyApp({super.key});

//   @override

//   Widget build(BuildContext context) {

//     DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

//      void getCurrentAppTheme() async {
//     themeChangeProvider.darkTheme =
//         await themeChangeProvider.darkThemePreference.getTheme();
//   }
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/': (context) =>
//             SettingsScreen(), // Replace SignInScreen with your initial screen
//         '/translation': (context) => TranslationScreen(),
//         '/login': (context) => SignInScreen(),
//         '/signup': (context) => RegisterScreen(),
//         '/summary': (context) => SummaryGeneratorScreen(),
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linguotech/services/theme_provider.dart';
import 'package:linguotech/Screens/Login/user_login.dart';
import 'package:linguotech/Screens/Register_Screen/user_register.dart';
import 'package:linguotech/Screens/Summarization/summary.dart';
import 'package:linguotech/Screens/Translation_Screen/translate.dart';
import 'package:linguotech/Screens/settings/settings.dart';
import 'package:linguotech/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  await themeChangeProvider.darkThemePreference.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(themeChangeProvider: themeChangeProvider));
}

class MyApp extends StatelessWidget {
  final DarkThemeProvider themeChangeProvider;

  const MyApp({Key? key, required this.themeChangeProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => themeChangeProvider,
      child: Consumer<DarkThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Styles.themeData(themeProvider.darkTheme, context),
            initialRoute: '/',
            routes: {
              '/': (context) => SettingsScreen(),
              '/translation': (context) => TranslationScreen(),
              '/login': (context) => SignInScreen(),
              '/signup': (context) => RegisterScreen(),
              '/summary': (context) => SummaryGeneratorScreen(),
            },
          );
        },
      ),
    );
  }
}
