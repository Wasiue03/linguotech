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
    'Summary': 'خلاصہ',
    'Camera': 'کیمرا',
    'Translate': 'ترجمہ',
    'History': 'تاریخچہ',
    'Text Summarization': 'متن خلاصہ کاری',
    'Enter Web Link': 'ویب لنک درج کریں',
    'Enter Link': 'لنک درج کریں',
    'Generate Summary': 'خلاصہ تشکیل دیں',
    'Only Urdu characters are allowed': 'صرف اردو حروف مجاز ہیں',
    'Only English characters are allowed': 'صرف انگریزی حروف مجاز ہیں',
    'Enter Text Here...': 'یہاں متن درج کریں...',
    'Generate': 'تشکیل دیں',
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
