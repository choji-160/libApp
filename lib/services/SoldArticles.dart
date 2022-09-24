// ignore_for_file: body_might_complete_normally_nullable, avoid_print, file_names

import 'package:http/http.dart' as http;
import '../model/soldArticle.dart';
import '../views/apiKeyInput.dart';



class SoldArticles{
  Future<List<SoldArticle>?> getSoldArticles() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '$apiKey/soldarticles'));
    print("soldarticles : $apiKey");
    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return SoldArticleFromJson(res);
    } else {
      print(response.reasonPhrase);
    }
  }
}