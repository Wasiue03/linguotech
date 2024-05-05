import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linguotech/Screens/Translation_Screen/Ur_translate_Screen.dart';
import 'package:linguotech/widgets/langauge_Screens.dart';
import 'package:linguotech/widgets/Nav_Bar/Navigation_bar.dart';

class EngTranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<EngTranslationScreen> {
  late TextEditingController inputController;
  String translatedText = '';
  String error = '';

  @override
  void initState() {
    super.initState();
    inputController = TextEditingController();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  Future<void> translateText() async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var requestBody = jsonEncode({"english_text": inputController.text});

      var response = await http.post(
        Uri.parse('http://10.0.2.2:5000/translate'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var decodedResponse = jsonDecode(response.body);
        setState(() {
          translatedText = decodedResponse['translated_text'];
          error = '';
        });
      } else {
        setState(() {
          translatedText = '';
          error = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        translatedText = '';
        error = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Center(
            child: Text(
          'English',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        )),
      ),
      body: Column(
        children: [
          Language(
            onEnglishPressed: () {
              debugPrint("Here");
              ElevatedButton(
                onPressed: () {},
                child: Text('Urdu'),
              );
            },
            onUrduPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UrTranslationScreen()),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  SizedBox(
                    height: 250, // Increase the height of the card
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Text(
                              'English',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: TextField(
                              controller: inputController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Type here...',
                              ),
                              minLines: 1,
                              maxLines: null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: translateText,
                    child: Container(
                      width: 80, // Set the width of the button
                      child: Center(
                        child: Text('Translate'),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 250, // Increase the height of the card
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Urdu',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Action for copying translated text
                                  },
                                  icon: Icon(Icons.copy),
                                  tooltip: 'Copy',
                                ),
                              ],
                            ),
                            if (translatedText.isNotEmpty) Text(translatedText),
                            if (error.isNotEmpty)
                              Text(error, style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        child: CustomBottomNavigationBar(),
      ),
    );
  }
}
