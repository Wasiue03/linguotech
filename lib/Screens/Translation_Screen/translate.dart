import 'package:flutter/material.dart';
import 'package:linguotech/model/translation_urdu/ur_to_eng.dart';

class TranslationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
      ),
      body: TranslateBody(),
    );
  }
}

class TranslateBody extends StatefulWidget {
  @override
  _TranslateBodyState createState() => _TranslateBodyState();
}

class _TranslateBodyState extends State<TranslateBody> {
  String selectedLanguage = 'Urdu';
  String urduText = '';
  String translatedText = '';
  final TranslateLogic translateLogic = TranslateLogic();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LanguageOption(
                language: 'Urdu',
                isSelected: selectedLanguage == 'Urdu',
                onTap: () {
                  changeLanguage('Urdu');
                },
              ),
              SizedBox(width: 20),
              LanguageOption(
                language: 'English',
                isSelected: selectedLanguage == 'English',
                onTap: () {
                  changeLanguage('English');
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                urduText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Enter Urdu Text',
              border: OutlineInputBorder(),
            ),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: TranslationCard(
            language: 'English',
            text: translatedText,
            onSpeechIconPressed: () {
              // Add functionality for speech icon pressed
            },
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            translateText();
          },
          child: Text('Translate'),
        ),
      ],
    );
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  Future<void> translateText() async {
    try {
      final translation = await translateLogic.translateText(urduText);
      print("Translation result: $translation");

      setState(() {
        translatedText = translation;
      });
    } catch (error) {
      print("Translation error: $error");
      setState(() {
        translatedText = 'Translation Error';
      });
    }
  }
}

class LanguageOption extends StatelessWidget {
  const LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Color.fromARGB(255, 57, 12, 162),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          language,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class TranslationCard extends StatelessWidget {
  const TranslationCard({
    required this.language,
    required this.text,
    required this.onSpeechIconPressed,
  });

  final String language;
  final String text;
  final VoidCallback onSpeechIconPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              language,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              text,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_up),
                  onPressed: onSpeechIconPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
