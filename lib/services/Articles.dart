// ignore_for_file: body_might_complete_normally_nullable, avoid_print

import 'package:http/http.dart' as http;
import 'package:librairiedumaroc/model/article.dart';

import '../views/apiKeyInput.dart';

class Articles {
  Future<List<Article>?> getArticles() async {
    var request = http.Request(
        'GET', Uri.parse('$apiKey/articles'));
    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return articleFromJson(res);
    } else {
      print(response.reasonPhrase);
    }
  }
}
