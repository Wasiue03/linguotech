import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linguotech/services/theme_provider.dart';

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
    final isDarkTheme = themeProvider.darkTheme;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: isDarkTheme ? Colors.orange : Colors.blue,
      unselectedItemColor: isDarkTheme ? Colors.white : Colors.black,
      backgroundColor: isDarkTheme ? Colors.black : Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.summarize_rounded),
          label: 'Summary',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt_rounded),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.translate_rounded),
          label: 'Translate',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
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
        Navigator.pushReplacementNamed(context, '/camera');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/translation');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/history');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/');
        break;
      default:
        print('Invalid index');
    }
  }
}
