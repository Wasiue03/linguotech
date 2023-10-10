import 'package:flutter/material.dart';
import 'package:linguotech/Components/navbar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedLanguage = 'English';
  String englishText = 'Hello, how are you?';
  String urduTranslation = 'مرحبا، آپ کیسے ہیں؟';

  int selectedIndex = 0; // Add this line

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
                  language: 'English',
                  isSelected: selectedLanguage == 'English',
                  onTap: () {
                    changeLanguage('English');
                  },
                ),
                SizedBox(width: 20),
                LanguageOption(
                  language: 'Urdu',
                  isSelected: selectedLanguage == 'Urdu',
                  onTap: () {
                    changeLanguage('Urdu');
                  },
                ),
              ],
            ),
          ),
          // English Text Card
          Expanded(
            child: TranslationCard(
              language: 'English',
              text: englishText,
              onSpeechIconPressed: () {
                // Implement text-to-speech functionality here
                print('Text-to-speech for English text');
              },
              onTranslateButtonPressed: () {
                // Implement translation functionality here
                print('Translate button pressed');
              },
            ),
          ),
          SizedBox(height: 20),
          // Urdu Translation Card
          Expanded(
            child: TranslationCard(
              language: 'Urdu',
              text: urduTranslation,
              onSpeechIconPressed: () {},
              onTranslateButtonPressed: () {},
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyBottomNavigationBar(
        selectedIndex: selectedIndex,
        onNavItemTapped: _onNavItemTapped,
      ),
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      selectedIndex = index;
      // Handle navigation to different screens based on the selected index
    });
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
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
  final VoidCallback onTranslateButtonPressed;

  TranslationCard({
    required this.language,
    required this.text,
    required this.onSpeechIconPressed,
    required this.onTranslateButtonPressed,
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
                ElevatedButton(
                  onPressed: onTranslateButtonPressed,
                  child: Text('Translate'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
