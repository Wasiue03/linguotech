import 'package:flutter/material.dart';
import 'package:linguotech/Screens/Translation_Screen/Eng_translate_Screen.dart';

class Language extends StatelessWidget {
  final VoidCallback onEnglishPressed;
  final VoidCallback onUrduPressed;

  Language({
    required this.onEnglishPressed,
    required this.onUrduPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () => EngTranslationScreen(),
            child: Text('English'),
          ),
          ElevatedButton(
            onPressed: onUrduPressed,
            child: Text('Urdu'),
          ),
        ],
      ),
    );
  }
}
