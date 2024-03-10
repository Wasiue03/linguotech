import 'package:flutter/material.dart';

class SummaryGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Summary Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SummaryGeneratorScreen(),
    );
  }
}

class SummaryGeneratorScreen extends StatefulWidget {
  @override
  _SummaryGeneratorScreenState createState() => _SummaryGeneratorScreenState();
}

class _SummaryGeneratorScreenState extends State<SummaryGeneratorScreen> {
  TextEditingController _inputController = TextEditingController();
  TextEditingController _outputController = TextEditingController();
  String selectedLanguage = 'Urdu';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Text Summarization',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              changeLanguage('Urdu');
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                border: selectedLanguage == 'Urdu'
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Colors
                                              .black, // Adjust the underline color
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              decoration: BoxDecoration(
                                border: selectedLanguage == 'English'
                                    ? Border(
                                        bottom: BorderSide(
                                          color: Colors
                                              .black, // Adjust the underline color
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
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.link),
                    SizedBox(width: 5),
                    Text(
                      'Add link here',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _inputController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: 'Enter Text Here...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Logic for generating summary
                    String inputText = _inputController.text;
                    // Placeholder logic for summary generation
                    String summary = generateSummary(inputText);
                    _outputController.text = summary;
                  },
                  child: Text('Generate'),
                ),
                SizedBox(height: 25),
                TextField(
                  controller: _outputController,
                  maxLines: 10,
                  readOnly: true,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelText: 'Summary',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Placeholder function for generating summary
  String generateSummary(String inputText) {
    // Here you can implement your summary generation logic
    // For now, let's just return the input text
    return inputText;
  }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }
}
