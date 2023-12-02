// translate_logic.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslateLogic {
  Future<String> translateText(String urduText) async {
    // debugPrint('here');
    // const String flaskServerUrl = "localhost:5000";
    // debugPrint('1');
    // const String apiEndpoint = '/';
    // debugPrint('2');

    final Map<String, dynamic> requestData = {
      'urdu_sentence': urduText,
    };

    try {
      debugPrint('Before rqst');
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/translate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestData),
      );
      // Add a timeout here

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['translation'];
      } else {
        // Handle error
        debugPrint('Error: ${response.statusCode}');
        return 'Translation Error';
      }
    } catch (error) {
      // Handle network or other errors
      print('Error: $error');
      return 'Translation Error';
    }
  }
}
