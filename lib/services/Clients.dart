// ignore_for_file: avoid_print, body_might_complete_normally_nullable, file_names

import '../model/client.dart';
import 'package:http/http.dart' as http;

class Clients {
  Future<List<Client>?> getClients() async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://7655-196-119-154-24.eu.ngrok.io/clients'));

    http.StreamedResponse response = await request.send();
    var res = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      return clientFromJson(res);
    } else {
      print(response.reasonPhrase);
    }
  }
}