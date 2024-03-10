// widgets/english_text_card.dart
import 'package:flutter/material.dart';

class EnglishTextCard extends StatelessWidget {
  final String translatedText;

  EnglishTextCard(this.translatedText);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        elevation: 5,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'English',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () async {
                      // Implement text-to-speech functionality for English text
                    },
                  ),
                ],
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
                      // Add functionality to copy translated text
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
