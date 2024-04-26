import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

Future getImageTotext(final imagePath) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText =
      await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
  String text = recognizedText.text.toString();
  return text;
}

class Camera extends StatefulWidget {
  const Camera({super.key});

  @override
  State<Camera> createState() => _CameraState();
}

late String s = "";

class _CameraState extends State<Camera> {
  final ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.white60,
        body: Column(
          children: [
            Container(
              height: 250,
              width: 250,
              child: Center(
                child: GestureDetector(
                    onTap: () async {
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      String a = await getImageTotext(image!.path);
                      setState(() {
                        s = a;
                      });
                    },
                    child: const Icon(
                      Icons.file_copy,
                    )),
              ),
            ),
            Text(
              s,
              style: TextStyle(color: Colors.black, fontSize: 20),
            )
          ],
        ),
      )),
    );
  }
}
