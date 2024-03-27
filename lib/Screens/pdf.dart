import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFPickerScreen extends StatefulWidget {
  @override
  _PDFPickerScreenState createState() => _PDFPickerScreenState();
}

class _PDFPickerScreenState extends State<PDFPickerScreen> {
  List<String> _pdfPaths = [];

  Future<void> _pickPDF() async {
    // Request storage permission
    final permissionStatus = await Permission.storage.request();

    if (permissionStatus.isGranted) {
      // Permission granted, proceed with picking PDF
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (result != null) {
          setState(() {
            _pdfPaths.clear();
            _pdfPaths.addAll(result.paths.map((path) => path!));
          });
        }
      } catch (e) {
        print("Error picking PDF: $e");
      }
    } else if (permissionStatus.isDenied) {
      // Permission denied, explain to user and offer options
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Storage permission is required to access PDFs. Please enable it in app settings.",
          ),
          action: SnackBarAction(
            label: "Settings",
            onPressed: () {
              openAppSettings(); // Function to open app settings (implementation depends on platform)
            },
          ),
        ),
      );
    } else if (permissionStatus.isPermanentlyDenied) {
      // Permission permanently denied, guide user to app settings
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Storage permission is permanently denied. Please enable it in app settings.",
          ),
          action: SnackBarAction(
            label: "Settings",
            onPressed: () {
              openAppSettings(); // Function to open app settings (implementation depends on platform)
            },
          ),
        ),
      );
    }
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
              onPressed: _pickPDF,
              child: Text('Pick PDF Files'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _pdfPaths.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_pdfPaths[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
