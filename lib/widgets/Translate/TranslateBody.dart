// widgets/translation_body.dart
import 'package:flutter/material.dart';
import 'package:linguotech/widgets/language_selectot.dart';
import 'package:linguotech/widgets/translate/english_text_card.dart';
import 'package:linguotech/widgets/translate/urdu_text_card.dart';

class TranslateBody extends StatefulWidget {
  @override
  _TranslateBodyState createState() => _TranslateBodyState();
}

class _TranslateBodyState extends State<TranslateBody> {
  String selectedLanguage = 'Urdu';
  String translatedText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        LanguageSelector(selectedLanguage, changeLanguage),
        UrduTextCard(),
        EnglishTextCard(translatedText),
      ],
    );
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }
}
