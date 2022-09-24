// ignore_for_file: avoid_print, body_might_complete_normally_nullable, file_names

import 'package:librairiedumaroc/model/return.dart';
import 'package:http/http.dart' as http;

import '../views/apiKeyInput.dart';

class Returns {
  Future<List<Return>?> getReturns() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '$apiKey/returns'));
    print("returns : $apiKey");
    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return returnFromJson(res);
    } else {
      print(response.reasonPhrase);
    }
  }
}