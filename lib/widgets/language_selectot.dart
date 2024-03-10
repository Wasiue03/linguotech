// widgets/language_selector.dart
import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onChangeLanguage;

  LanguageSelector(this.selectedLanguage, this.onChangeLanguage);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  onChangeLanguage('Urdu');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    border: selectedLanguage == 'Urdu'
                        ? Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          )
                        : null,
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
                Icons.compare_arrows,
                size: 30,
                color: Colors.black,
              ),
              SizedBox(width: 20),
              GestureDetector(
                onTap: () {
                  onChangeLanguage('English');
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                    border: selectedLanguage == 'English'
                        ? Border(
                            bottom: BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          )
                        : null,
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
      ],
    );
  }
}
