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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Summary')),
        backgroundColor: Color.fromARGB(255, 224, 106, 3),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            margin: EdgeInsets.only(top: 40),
            child: Column(
              children: [
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
                SizedBox(height: 40),
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
}
