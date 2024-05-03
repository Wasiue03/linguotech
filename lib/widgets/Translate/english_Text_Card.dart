import 'package:flutter/material.dart';

class EnglishTextCard extends StatelessWidget {
  final String translatedText;
  final bool
      isEnglishSelected; // New parameter to indicate if English is selected
  final Function(String) onTextChanged;
  EnglishTextCard({
    required this.translatedText,
    required this.isEnglishSelected, // Constructor parameter
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Padding(
            padding: EdgeInsets.all(10),
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

                // TextField conditionally enabled based on the selected language
                if (isEnglishSelected)
                  TextField(
                    onChanged: (text) {
                      // Handle text input
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter text...',
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.black),
                    ),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  translatedText,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 60),
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
      ),
    );
  }
}
