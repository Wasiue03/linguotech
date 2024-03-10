import 'package:flutter/material.dart';
import 'package:linguotech/widgets/icons.dart';
import 'package:linguotech/widgets/language_selectot.dart';

void main() {
  runApp(SummaryGenerator());
}

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
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            child: Column(
              children: [
                LanguageSelector(selectedLanguage, changeLanguage),
                SizedBox(height: 10),
                LinkIcon(),
                SizedBox(height: 20),
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
