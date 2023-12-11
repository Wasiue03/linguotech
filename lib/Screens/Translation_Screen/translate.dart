import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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

  FlutterTts flutterTts = FlutterTts();

  // Function to read text aloud
  Future<void> speakText(String text) async {
    await flutterTts.speak(text);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
  }

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
                    border: selectedLanguage == 'Urdu'
                        ? Border(
                            bottom: BorderSide(
                              color: Colors.black, // Adjust the underline color
                              width:
                                  2.0, // Adjust the thickness of the underline
                            ),
                          )
                        : null, // No border when not selected
                  ),
                  child: Text(
                    'Urdu',
                    style: TextStyle(
                      color: selectedLanguage == 'Urdu'
                          ? Colors.orange
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: selectedLanguage == 'Urdu'
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20),
              Icon(
                Icons.compare_arrows, // Double-headed arrow icon
                size: 30,
                color: Colors.black,
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  changeLanguage('English');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    border: selectedLanguage == 'English'
                        ? Border(
                            bottom: BorderSide(
                              color: Colors.black, // Adjust the underline color
                              width:
                                  2.0, // Adjust the thickness of the underline
                            ),
                          )
                        : null, // No border when not selected
                  ),
                  child: Text(
                    'English',
                    style: TextStyle(
                      color: selectedLanguage == 'English'
                          ? Colors.orange
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      decoration: selectedLanguage == 'English'
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Urdu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: () async {
                          await speakText(urduTextController.text);
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: urduTextController,
                    onChanged: (value) {
                      // No need to use setState since it's a stateful widget
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Urdu Text',
                      alignLabelWithHint: true, // Align hint to the start
                      border: InputBorder.none, // Remove underline
                    ),
                    textAlign: TextAlign.start, // Align text to the start
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        translateText();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        minimumSize: Size(10, 20),
                      ),
                      child: Text(
                        'Translate',
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.volume_up),
                          onPressed: () async {
                            await speakText(translatedText);
                          },
                        ),
                      ],
                    ),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.star_border),
                          onPressed: () {
                            // Add functionality for favorite icon pressed
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            copyToClipboard();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  void copyToClipboard() {
    FlutterClipboard.copy(translatedText)
        .then((value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Translated text copied to clipboard'),
                backgroundColor: Colors.green,
              ),
            ))
        // ignore: invalid_return_type_for_catch_error
        .catchError(
            (error) => debugPrint('Error copying to clipboard: $error'));
  }
}
