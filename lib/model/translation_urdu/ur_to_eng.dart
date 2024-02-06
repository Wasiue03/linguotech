import 'dart:convert';

import 'package:http/http.dart' as http;

class TranslateLogic {
  Future<String> translatetext(String urduText) async {
    try {
      print("API Called");
      var headers = {'Content-Type': 'application/json'};
      var request =
          http.Request('POST', Uri.parse('http://10.0.2.2:5000/translate'));
      request.body = json.encode({"urdu_sentence": urduText});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Return the translated text instead of printing
        return await response.stream.bytesToString();
      } else if (response.statusCode == 500) {
        // Handle the case when the server returns HTTP status code 500
        return 'Unknown Vocabulary';
      } else {
        // Return an error message if the request was not successful
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (error) {
      // Return an error message if there was an exception
      return 'Error: $error';
    }
  }
}

  // Future<String> translatetext(String urduText) async {
  //   final response = await http.post(
  //     Uri.parse('http://10.0.2.2:5000/translate'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode({'urdu_sentence': urduText}),
  //   );

  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> data = json.decode(response.body);
  //     return data['translation'];
  //   } else {
  //     throw Exception('Failed to load translation');
  //   }
  // }

