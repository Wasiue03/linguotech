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
  String translatedText = '';
  final TranslateLogic translateLogic = TranslateLogic();
  final TextEditingController urduTextController = TextEditingController();

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
              GestureDetector(
                onTap: () {
                  changeLanguage('Urdu');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        selectedLanguage == 'Urdu' ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Urdu',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  changeLanguage('English');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedLanguage == 'English'
                        ? Colors.blue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: urduTextController,
            onChanged: (value) {
              // No need to use setState since it's a stateful widget
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
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'English',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    translatedText,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () {
                          // Add functionality for speech icon pressed
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
      final translation =
          await translateLogic.translatetext(urduTextController.text);

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
