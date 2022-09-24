// ignore_for_file: avoid_print, body_might_complete_normally_nullable, file_names

import 'package:librairiedumaroc/model/returnedArticle.dart';
import 'package:http/http.dart' as http;

import '../views/apiKeyInput.dart';

class ReturnedArticles {
  Future<List<ReturnedArticle>?> getReturnedAtricles() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '$apiKey/returnedarticles'));
    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return returnedArticleFromJson(res);
    } else {
      print(response.reasonPhrase);
    }
  }
}