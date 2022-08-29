// To parse this JSON data, do
//
//     final credit = creditFromJson(jsonString);

import 'dart:convert';

List<Credit> creditFromJson(String str) => List<Credit>.from(json.decode(str).map((x) => Credit.fromJson(x)));

String creditToJson(List<Credit> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Credit {
    Credit({
      required  this.id,
      required  this.avance,
      required  this.rest,
      required  this.total,
      required  this.date,
      required  this.client,
      required  this.numeroCommande,
      required  this.utilisateur,
    });

    num? id;
    num? avance;
    num? rest;
    num? total;
    String? date;
    String? client;
    String? numeroCommande;
    String? utilisateur;

    factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        id: json["id"],
        avance: json["avance"],
        rest: json["rest"],
        total: json["total"],
        date: json["date"],
        client: json["client"],
        numeroCommande: json["numero_commande"],
        utilisateur: json["utilisateur"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "avance": avance,
        "rest": rest,
        "total": total,
        "date": date,
        "client": client,
        "numero_commande": numeroCommande,
        "utilisateur": utilisateur,
    };
}