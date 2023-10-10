import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onNavItemTapped;

  MyBottomNavigationBar({
    required this.selectedIndex,
    required this.onNavItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.language),
          label: 'Language',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onNavItemTapped,
    );
  }
}
