import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linguotech/services/theme_provider.dart';
import 'package:linguotech/widgets/Nav_Bar/Navigation_bar.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    bool _isEnglishSelected = true;
    // Access the DarkThemeProvider instance using Provider.of
    DarkThemeProvider themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Card(
              child: ListTile(
                title: Text('Dark Mode'),
                trailing: Switch(
                  value: themeProvider.darkTheme,
                  onChanged: (value) {
                    setState(() {
                      themeProvider.darkTheme = value;
                    });
                  },
                  inactiveTrackColor:
                      Colors.grey[400], // Change switch color for white mode
                ),
              ),
            ),
            Text(
              'Language',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Card(
              child: ListTile(
                title: Text('English'),
                leading: Radio(
                  value: true,
                  groupValue: _isEnglishSelected,
                  onChanged: (value) {
                    setState(() {
                      _isEnglishSelected = value!;
                    });
                  },
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Urdu'),
                leading: Radio(
                  value: false,
                  groupValue: _isEnglishSelected,
                  onChanged: (value) {
                    setState(() {
                      _isEnglishSelected = value!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  // Method to update theme based on selection
  void _updateTheme(bool isDarkMode) {
    DarkThemeProvider themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    themeProvider.darkTheme = isDarkMode;
  }
}
