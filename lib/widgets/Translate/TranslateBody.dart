import 'package:flutter/material.dart';
import 'package:linguotech/widgets/Translate/english_Text_Card.dart';
import 'package:linguotech/widgets/Translate/urdu_Text_Card.dart';
import 'package:linguotech/widgets/language_selectot.dart';

class TranslateBody extends StatefulWidget {
  @override
  _TranslateBodyState createState() => _TranslateBodyState();
}

class _TranslateBodyState extends State<TranslateBody> {
  String selectedLanguage = 'Urdu'; // Default language is Urdu
  String translatedText = '';
  bool _isDarkMode = false;
  bool isEnglishSelected = false;
  bool isUrduSelected = true;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LanguageSelector(selectedLanguage, changeLanguage, _isDarkMode),
          // Input card based on selected language
          if (selectedLanguage == 'Urdu')
            UrduTextCard(
              onTextTranslated: (text) {
                setState(() {
                  translatedText = text;
                });
              },
              isEnglishSelected: isEnglishSelected,
              isUrduSelected: isUrduSelected,
            ),

          if (selectedLanguage == 'English')
            EnglishTextCard(
              translatedText: translatedText,
              isEnglishSelected: true,
              onTextChanged: (text) {
                setState(() {
                  translatedText = text;
                });
              },
            ),
          // Button between Urdu and English cards

          ElevatedButton(
            onPressed: () {
              // Handle button press
            },
            child: Text('Translate'),
          ),
          // Output card (the other language)
          if (selectedLanguage == 'Urdu')
            EnglishTextCard(
              translatedText: translatedText,
              onTextChanged:
                  (text) {}, // Dummy function as it's not used for output
              isEnglishSelected: false,
            ), // Output card for Urdu input
          if (selectedLanguage == 'English')
            UrduTextCard(
              onTextTranslated: (text) {
                setState(() {
                  translatedText = text;
                });
              },
              isEnglishSelected: false,
              isUrduSelected: false,
            ), // Output card for English input
          // Additional widgets can be added here
        ],
      ),
    );
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
      // Clear translated text when switching languages
      translatedText = '';
      if (selectedLanguage == 'Urdu') {
        isEnglishSelected = false;
        isUrduSelected = true;
      } else {
        isEnglishSelected = true;
        isUrduSelected = false;
      }
    });
  }
}
