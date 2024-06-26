import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linguotech/services/theme_provider.dart';
import 'package:linguotech/services/language_provider.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDarkTheme = themeProvider.darkTheme;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: isDarkTheme ? Colors.orange : Colors.blue,
      unselectedItemColor: isDarkTheme ? Colors.white : Colors.black,
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.summarize_rounded),
          label: languageProvider.getLocalizedString('Summary'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt_rounded),
          label: languageProvider.getLocalizedString('Camera'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.translate_rounded),
          label: languageProvider.getLocalizedString('Translate'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: languageProvider.getLocalizedString('Feedback'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: languageProvider.getLocalizedString('Settings'),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
        navigateTo(index, context);
      },
      showSelectedLabels: true,
      showUnselectedLabels: true,
    );
  }

  void navigateTo(int index, BuildContext context) {
    print('Selected index: $index');
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/summary');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/Camera');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/english');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/feedback');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/settings');
        break;
      default:
        print('Invalid index');
    }
  }
}
