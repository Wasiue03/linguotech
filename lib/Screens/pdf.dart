import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:linguotech/Screens/Summarization/summary.dart';

class PDFPickerScreen extends StatefulWidget {
  @override
  _PDFPickerScreenState createState() => _PDFPickerScreenState();
}

class _PDFPickerScreenState extends State<PDFPickerScreen> {
  String? _extractedText;

  Future<void> _pickPDFAndExtractText() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        String? path = result.files.single.path;
        if (path != null) {
          // Call Flask server to extract text from the selected PDF
          String url = 'http://10.113.79.140:5000/extract-text';
          var request = http.MultipartRequest('POST', Uri.parse(url))
            ..files.add(await http.MultipartFile.fromPath('file', path));

          var streamedResponse = await request.send();
          var response = await http.Response.fromStream(streamedResponse);

          if (response.statusCode == 200) {
            String extractedText = response.body;

            // Check if the extracted text is Urdu
            if (_isUrdu(extractedText)) {
              try {
                // Attempt to decode the text from UTF-8
                extractedText =
                    utf8.decode(json.decode(extractedText)['text'].codeUnits);
              } catch (e) {
                // Fallback to treating the text as Unicode
                extractedText = json.decode(extractedText)['text'];
              }
            }

            // Navigate to the summary screen and pass the extracted text
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SummaryGeneratorScreen(
                  extractedText: extractedText,
                ),
              ),
            );
          } else {
            // Handle server errors
            print('Failed to fetch PDF text: ${response.statusCode}');
          }
        }
      }
    } catch (e) {
      // Handle errors
      print('Error picking PDF and extracting text: $e');
    }
  }

  bool _isUrdu(String jsonString) {
    // Decode the JSON string to obtain the actual text
    String text = json.decode(jsonString)["text"];
    print('Text to check for Urdu characters: $text');

    // Check if the text contains any characters in the Urdu Unicode range
    bool isUrdu =
        text.contains(RegExp(r'[\u0600-\u06FF\uFB50-\uFDFF\uFE70-\uFEFF]'));
    print('Is Urdu? $isUrdu');

    return isUrdu;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickPDFAndExtractText,
              child: Text('Pick PDF Files'),
            ),
            SizedBox(height: 20),
            if (_extractedText != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _extractedText!,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
