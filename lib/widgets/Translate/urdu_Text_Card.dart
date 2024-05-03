// widgets/translation_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:linguotech/model/translation_urdu/ur_to_eng.dart';

class UrduTextCard extends StatefulWidget {
  final Function(String) onTextTranslated;
  final bool isEnglishSelected;
  final bool isUrduSelected;

  UrduTextCard({
    required this.onTextTranslated,
    required this.isEnglishSelected,
    required this.isUrduSelected,
  });

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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
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
                    icon: Icon(
                      Icons.volume_up_outlined,
                    ),
                    onPressed: () async {
                      await speakText(urduTextController.text);
                    },
                  ),
                ],
              ),
              // Conditionally show TextField based on language selection
              if (!widget.isEnglishSelected && widget.isUrduSelected)
                TextField(
                  controller: urduTextController,
                  enabled: widget
                      .isUrduSelected, // Enable/disable based on isUrduSelected
                  onChanged: (value) {
                    // No need to use setState since it's a stateful widget
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter text...',
                    alignLabelWithHint: true,
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              SizedBox(
                height: 170,
              )
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

      // Call the callback function with the translated text
      widget.onTextTranslated(translation);
    } catch (error) {
      print("Translation error: $error");
      setState(() {
        translatedText = 'Translation Error';
      });
    }
  }
}
