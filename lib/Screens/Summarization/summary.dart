import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:linguotech/Screens/Drawer/drawer.dart';
import 'package:linguotech/Screens/pdf.dart';
import 'package:linguotech/model/Summarization/summary_model.dart';
import 'package:linguotech/services/language_provider.dart';
import 'package:linguotech/widgets/Nav_Bar/Navigation_bar.dart';
import 'package:linguotech/widgets/language_selectot.dart';
import 'package:provider/provider.dart';

class SummaryGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Summary Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SummaryGeneratorScreen(
        extractedText: '',
      ),
    );
  }
}

class SummaryGeneratorScreen extends StatefulWidget {
  final String extractedText;

  SummaryGeneratorScreen({required this.extractedText});
  @override
  _SummaryGeneratorScreenState createState() => _SummaryGeneratorScreenState();
}

class _SummaryGeneratorScreenState extends State<SummaryGeneratorScreen> {
  TextEditingController _inputController = TextEditingController();
  TextEditingController _outputController = TextEditingController();
  String selectedLanguage = 'English';
  String url = '';
  String _errorText = '';
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    if (selectedLanguage == 'English') {
      _inputController.text = widget.extractedText;
    } else if (selectedLanguage == 'Urdu') {
      _inputController.text = _reverseText(widget.extractedText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: _isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text(
          languageProvider.getLocalizedString('Text Summarization'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Container(
            child: Column(
              children: [
                // Language selector widget
                LanguageSelector(selectedLanguage, changeLanguage, _isDarkMode),
                SizedBox(height: 10),
                // GestureDetector for link input dialog
                GestureDetector(
                  onTap: () {
                    _showLinkInputDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(
                        Icons.link,
                        color: Colors.orange,
                      ),
                      SizedBox(
                          width: 10), // Adjust spacing between icons if needed
                      IconButton(
                        icon: Icon(
                          Icons.add_circle_rounded,
                          color: Colors.orange,
                        ),
                        onPressed: () async {
                          // TextEditingController summaryController =
                          //     TextEditingController();
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
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none, // Remove border
                        errorText: _errorText.isNotEmpty ? _errorText : null,
                      ),

                      onChanged: (value) {
                        // Check if the entered text contains English characters
                        if (selectedLanguage == 'Urdu' &&
                            _containsEnglish(value)) {
                          setState(() {
                            _errorText = languageProvider.getLocalizedString(
                                'Only Urdu characters are allowed');
                          });
                        } else if (selectedLanguage == 'English' &&
                            _containsNonEnglish(value)) {
                          setState(() {
                            _errorText = languageProvider.getLocalizedString(
                                'Only English characters are allowed');
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
                    String inputText = _inputController.text;
                    String _selectedLanguage =
                        selectedLanguage; // Assuming you have a variable to store the selected language

                    if (_selectedLanguage == 'English') {
                      String engSummary = await fetchEnglishSummary(inputText);
                      _outputController.text = engSummary;
                    } else if (_selectedLanguage == 'Urdu') {
                      String urduSummary = await fetchUrduSummary(inputText);
                      _outputController.text = urduSummary;
                    } else {
                      // Handle unsupported language
                      _outputController.text = 'Unsupported language';
                    }
                  },
                  child: Text(
                    languageProvider.getLocalizedString('Generate'),
                    style: TextStyle(
                      color: _isDarkMode ? Colors.white : Colors.orange,
                    ),
                  ),
                ),

                SizedBox(height: 10),
// Output text field
                Card(
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
                        labelText:
                            languageProvider.getLocalizedString('Summary'),
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

  // Function to reverse the text string
// Function to reverse the text string
  String _reverseText(String text) {
    List<String> lines = text.split('\n');
    List<String> reversedLines = [];

    // Reverse the order of lines
    for (int i = lines.length - 1; i >= 0; i--) {
      String line = lines[i];
      String reversedLine = line.split(' ').reversed.join(' ');
      reversedLines.add(reversedLine);
    }

    // Join the reversed lines with newline characters
    String reversedText = reversedLines.join('\n');

    // Reverse the direction of the text to be right-to-left
    return reversedText.split('').reversed.join('');
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
      // Automatically set the input text controller based on the selected language
      if (selectedLanguage == 'English') {
        _inputController.text = widget.extractedText;
      } else if (selectedLanguage == 'Urdu') {
        _inputController.text = _reverseText(widget.extractedText);
      }
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
            'http://10.113.71.199:5000/generate_summary'), // Replace with your server address
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
