// widgets/translation_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:linguotech/model/translation_urdu/ur_to_eng.dart';

class UrduTextCard extends StatefulWidget {
  @override
  _UrduTextCardState createState() => _UrduTextCardState();
}

class _UrduTextCardState extends State<UrduTextCard> {
  String translatedText = '';
  final TranslateLogic translateLogic = TranslateLogic();
  final TextEditingController urduTextController = TextEditingController();

  FlutterTts flutterTts = FlutterTts();

  // Function to read text aloud
  Future<void> speakText(String text) async {
    await flutterTts.speak(text);
    // await flutterTts.setPitch(1.0);
    // await flutterTts.setSpeechRate(0.5);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
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
    );
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
