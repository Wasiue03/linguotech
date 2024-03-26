import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linguotech/Screens/pdf.dart';
import 'package:linguotech/model/Summarization/summary_model.dart';
import 'package:linguotech/widgets/Nav_Bar/Navigation_bar.dart';
import 'package:linguotech/widgets/language_selectot.dart';

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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.link),
                      SizedBox(
                          width: 10), // Adjust spacing between icons if needed
                      IconButton(
                        icon: Icon(Icons.add_circle_rounded),
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PDFPickerScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10),
// Text input field
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                        border: InputBorder.none, // Remove border
                        errorText: _errorText.isNotEmpty ? _errorText : null,
                      ),
                      onChanged: (value) {
                        // Check if the entered text contains English characters
                        if (selectedLanguage == 'Urdu' &&
                            _containsEnglish(value)) {
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
                  ),
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

                    // Logic for generating summary
                    String urdu_Summary = await fetchUrduSummary(inputText);
                    _outputController.text = urdu_Summary;
                  },
                  child: Text(
                    'Generate',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
                SizedBox(height: 10),
// Output text field
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: _outputController,
                      maxLines: 9,
                      readOnly: true,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Summary',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        border: InputBorder.none, // Remove border
                      ),
                    ),
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

  void changeLanguage(String language) {
    setState(() {
      if ((selectedLanguage == 'English' && language == 'Urdu') ||
          (selectedLanguage == 'Urdu' && language == 'English')) {
        // Clear input and output fields when switching between Urdu and English
        _inputController.clear();
        _outputController.clear();
      }
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
                  String Web_Summary = await fetchSummaryFromLink(url);
                  _outputController.text = Web_Summary;
                  print("Yes");
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

  Future<String> fetchUrduSummary(String text) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var body = json.encode({'text': text});
      var response = await http.post(
        Uri.parse(
            'http://10.0.2.2:5000/generate_summary'), // Replace with your server address
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        String urduSummary = data['summary'];
        print(urduSummary); // Extract summary from response
        return urduSummary;
      } else {
        throw Exception('Failed to fetch summary: ${response.reasonPhrase}');
      }
    } catch (error) {
      return 'Error: $error';
    }
  }
}
