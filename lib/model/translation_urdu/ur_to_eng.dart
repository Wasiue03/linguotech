import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslateLogic {
  static const url = "http://127.0.0.1:5000/translate";
  Future<String> translateText(String urduText) async {
    try {
      final requestData = <String, dynamic>{
        'urdu_sentence': urduText,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final translation = data['translation'] as String;

        if (translation != null && translation.isNotEmpty) {
          return translation;
        } else {
          // Handle empty translation
          return 'Translation is empty';
        }
      } else {
        // Handle error
        debugPrint('Error: ${response.statusCode}, ${response.body}');
        return 'Error: ${response.statusCode}';
      }
    } catch (error) {
      // Handle network or other errors
      debugPrint('Error: $error');
      return 'Translation Error';
    }
  }
}
