import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linguotech/widgets/Nav_Bar/Navigation_bar.dart';
import 'package:linguotech/widgets/language_selectot.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  String url = '';
  String _errorText = '';

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
        backgroundColor: Color.fromARGB(255, 28, 56, 105),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            child: Column(
              children: [
                // Language selector widget
                LanguageSelector(selectedLanguage, changeLanguage),
                SizedBox(height: 10),
                // GestureDetector for link input dialog
                GestureDetector(
                  onTap: () {
                    _showLinkInputDialog(context);
                  },
                  child: Icon(Icons.link),
                ),
                SizedBox(height: 10),
                // Text input field
                TextFormField(
                  controller: _inputController,
                  maxLines: 9,
                  textAlign: selectedLanguage == 'Urdu'
                      ? TextAlign.right
                      : TextAlign.start,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: selectedLanguage == 'Urdu'
                        ? '...یہاں پر اردو لکھیں'
                        : 'Enter Text Here...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    errorText: _errorText.isNotEmpty ? _errorText : null,
                  ),
                  onChanged: (value) {
                    // Check if the entered text contains English characters
                    if (selectedLanguage == 'Urdu' && _containsEnglish(value)) {
                      setState(() {
                        _errorText = 'Only Urdu characters are allowed';
                      });
                    } else if (selectedLanguage == 'English' &&
                        _containsNonEnglish(value)) {
                      setState(() {
                        _errorText = 'Only English characters are allowed';
                      });
                    } else {
                      setState(() {
                        _errorText = '';
                      });
                    }
                  },
                  // Validation to prevent form submission if error exists
                  validator: (value) {
                    if (_errorText.isNotEmpty) {
                      return _errorText;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                // Button to generate summary
                ElevatedButton(
                  onPressed: () async {
                    // Logic for generating summary
                    String inputText = _inputController.text;
                    // Placeholder logic for summary generation
                    String EngSummary = await fetchEnglishSummary(inputText);
                    _outputController.text = EngSummary;
                  },
                  child: Text(
                    'Generate',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                SizedBox(height: 10),
                // Output text field
                TextFormField(
                  controller: _outputController,
                  maxLines: 9,
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
      // Custom bottom navigation bar widget
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }

  bool _containsEnglish(String text) {
    // Regular expression to check if text contains English characters
    return RegExp(r'[a-zA-Z]').hasMatch(text);
  }

  bool _containsNonEnglish(String text) {
    // Checks if the text contains characters other than English alphabets and spaces
    return RegExp(r'[^a-zA-Z ]').hasMatch(text);
  }

  // Placeholder function for generating summary
  // String generateSummary(String inputText) {
  // Here you can implement your summary generation logic
  // For now, let's just return the input text
  //   return inputText;
  // }

  void changeLanguage(String language) {
    setState(() {
      selectedLanguage = language;
      _errorText = '';
    });
  }

  Future<void> _showLinkInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Enter Web Link',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    url = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter Link',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  // Call a method to fetch summary from the provided link
                  String summary = await fetchSummaryFromLink(url);
                  _outputController.text = summary;
                  Navigator.of(context).pop(); // Close dialog
                },
                child: Text('Generate Summary'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> fetchSummaryFromLink(String url) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({'url': url}); // Encode the URL as JSON
      var response = await http.post(
        Uri.parse(
            'http://10.0.2.2:5000/summary'), // Replace with your server address
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String summary = data['summary'];
        print(summary); // Extract summary from response
        // Set the summary text to the output controller

        return summary;
      } else {
        throw Exception('Failed to fetch summary: ${response.reasonPhrase}');
      }
    } catch (error) {
      return 'Error: $error';
    }
  }

  Future<String> fetchEnglishSummary(String text) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({'text': text});
      var response = await http.post(
        Uri.parse(
            'http://10.0.2.2:5000/summarize'), // Replace with your server address
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String EngSummary = data['summary'];
        print(EngSummary); // Extract summary from response
        return EngSummary;
      } else {
        throw Exception('Failed to fetch summary: ${response.reasonPhrase}');
      }
    } catch (error) {
      return 'Error: $error';
    }
  }
}
