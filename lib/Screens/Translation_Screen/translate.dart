import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Translate extends StatefulWidget {
  @override
  _TranslateState createState() => _TranslateState();
}

class _TranslateState extends State<Translate> {
  String selectedLanguage = 'Urdu';
  String urduText = ''; // Empty Urdu text
  String translatedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translation App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Language Selection Bar
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
          // Urdu Text Input
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
          // Translated Text Card
          Expanded(
            child: TranslationCard(
              language: 'English',
              text: translatedText,
              onSpeechIconPressed: () {},
            ),
          ),
          SizedBox(height: 20),
          // Translate Button
          ElevatedButton(
            onPressed: () {
              translateText(); // Call the function to translate text
            },
            child: Text('Translate'),
          ),
        ],
      ),
    );
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  void translateText() async {
    const String flaskServerUrl = 'http://127.0.0.1:5000';
    const String apiEndpoint = '/translate';

    final Map<String, dynamic> requestData = {
      'urdu_sentence': urduText,
    };

    try {
      final response = await http.post(
        Uri.parse('$flaskServerUrl$apiEndpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          translatedText = data['translation'];
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
    }
  }
}

class LanguageOption extends StatelessWidget {
  final String language;
  final bool isSelected;
  final Function onTap;

  LanguageOption({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
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
  final String language;
  final String text;
  final VoidCallback onSpeechIconPressed;

  TranslationCard({
    required this.language,
    required this.text,
    required this.onSpeechIconPressed,
  });

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
