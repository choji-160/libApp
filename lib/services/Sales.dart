// ignore_for_file: body_might_complete_normally_nullable, avoid_print, unrelated_type_equality_checks

import 'package:librairiedumaroc/model/sale.dart';
import 'package:http/http.dart' as http;
import 'package:librairiedumaroc/views/apiKeyInput.dart';

class Sales {
  Future<List<Sale>?> getSales() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            '$apiKey/sales'));
    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return saleFromJson(res);
    } else {
      print(response.reasonPhrase);
    }
  }
}