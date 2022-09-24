// ignore_for_file: avoid_print, body_might_complete_normally_nullable, file_names

import '../model/credit.dart';
import 'package:http/http.dart' as http;

import '../views/apiKeyInput.dart';

class Credits {
  Future<List<Credit>?> getCredits() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '$apiKey/credits'));
    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return creditFromJson(res);
    } else {
      print(response.reasonPhrase);
    }
  }
}