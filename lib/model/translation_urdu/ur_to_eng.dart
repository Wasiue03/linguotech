import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TranslateLogic {
  Future<String> translatetext(String urduText) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/translate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'urdu_sentence': urduText}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['translation'];
    } else {
      throw Exception('Failed to load translation');
    }
  }
}
