import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:linguotech/services/theme_provider.dart';
import 'package:linguotech/widgets/Nav_Bar/Navigation_bar.dart';
import 'package:linguotech/services/language_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<DarkThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                languageProvider.getLocalizedString('Settings'),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  languageProvider.getLocalizedString('Theme'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      languageProvider.getLocalizedString('Dark Mode'),
                    ),
                    trailing: Switch(
                      value: themeProvider.darkTheme,
                      onChanged: (value) {
                        setState(() {
                          themeProvider.darkTheme = value;
                        });
                      },
                      inactiveTrackColor: Colors.grey[400],
                    ),
                  ),
                ),
                Text(
                  languageProvider.getLocalizedString('Language'),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      languageProvider.getLocalizedString('English'),
                    ),
                    leading: Radio(
                      value: 'English',
                      groupValue: languageProvider.selectedLanguage,
                      onChanged: (value) {
                        languageProvider.setSelectedLanguage('English');
                      },
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      languageProvider.getLocalizedString('Urdu'),
                    ),
                    leading: Radio(
                      value: 'Urdu',
                      groupValue: languageProvider.selectedLanguage,
                      onChanged: (value) {
                        languageProvider.setSelectedLanguage('Urdu');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: CustomBottomNavigationBar(),
        );
      },
    );
  }

  // Method to update theme based on selection
  void _updateTheme(bool isDarkMode) {
    DarkThemeProvider themeProvider =
        Provider.of<DarkThemeProvider>(context, listen: false);
    themeProvider.darkTheme = isDarkMode;
  }
}
