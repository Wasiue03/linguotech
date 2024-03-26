import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> fetchSummaryFromLink(String url) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'url': url}); // Encode the URL as JSON
    var response = await http.post(
      Uri.parse(
          'http://10.0.2.2:5000/summary'), // Replace with your server address
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String Web_Summary = data['summary'];
      print(Web_Summary); // Extract summary from response
      // Set the summary text to the output controller

      return Web_Summary;
    } else {
      throw Exception('Failed to fetch summary: ${response.reasonPhrase}');
    }
  } catch (error) {
    return 'Error: $error';
  }
}

Future<String> fetchEnglishSummary(String text) async {
  try {
    var headers = {'Content-Type': 'application/json'};
    var body = json.encode({'text': text});
    var response = await http.post(
      Uri.parse(
          'http://10.0.2.2:5000/summarize'), // Replace with your server address
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String EngSummary = data['summary'];
      print(EngSummary); // Extract summary from response
      return EngSummary;
    } else {
      throw Exception('Failed to fetch summary: ${response.reasonPhrase}');
    }
  } catch (error) {
    return 'Error: $error';
  }
}