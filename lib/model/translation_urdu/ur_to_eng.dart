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
        return 'Unknown ';
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

// Future<String> translateEnglishToUrdu(String englishText) async {
//   try {
//     var headers = {'Content-Type': 'application/json'};
//     var requestBody = jsonEncode({"english_sentence": 'Where are you?'});

//     var response = await http.post(
//       Uri.parse('http://10.0.2.2:5000/translate'),
//       headers: headers,
//       body: requestBody,
//     );

//     if (response.statusCode == 200) {
//       // Decode the response body to get the translated Urdu text
//       var decodedResponse = jsonDecode(response.body);
//       return decodedResponse['translated_text'];
//     } else {
//       // Handle error response
//       return 'Error: ${response.reasonPhrase}';
//     }
//   } catch (error) {
//     // Handle exceptions
//     return 'Error: $error';
//   }
// }
