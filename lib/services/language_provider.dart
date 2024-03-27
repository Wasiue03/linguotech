import 'package:flutter/material.dart';

class LanguageProvider with ChangeNotifier {
  String _selectedLanguage = 'English';

  String get selectedLanguage => _selectedLanguage;

  void toggleLanguage() {
    _selectedLanguage = _selectedLanguage == 'English' ? 'Urdu' : 'English';
    notifyListeners();
  }

  Map<String, String> _englishTranslations = {
    'Theme': 'Theme',
    'Dark Mode': 'Dark Mode',
    'Language': 'Language',
    'English': 'English',
    'Urdu': 'Urdu',
    'Settings': 'Settings',
  };

  Map<String, String> _urduTranslations = {
    'Theme': 'موڈ',
    'Dark Mode': 'تاریک موڈ',
    'Language': 'زبان',
    'English': 'انگریزی',
    'Urdu': 'اردو',
    'Settings': 'ترتیبات',
  };

  String getLocalizedString(String key) {
    if (_selectedLanguage == 'English') {
      return _englishTranslations[key] ?? key;
    } else {
      return _urduTranslations[key] ?? key;
    }
  }

  void setSelectedLanguage(String language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}
