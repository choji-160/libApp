// To parse this JSON data, do
//
//     final return = returnFromJson(jsonString);

import 'dart:convert';

List<Return> returnFromJson(String str) => List<Return>.from(json.decode(str).map((x) => Return.fromJson(x)));

String returnToJson(List<Return> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Return {
    Return({
      required this.idretour,
      required this.dateRetour,
      required this.utilisateur,
      required this.nombreArticle,
      required this.client,
      required this.numerocommande,
      required this.total,
    });

    num? idretour;
    String? dateRetour;
    String? utilisateur;
    num? nombreArticle;
    String? client;
    String? numerocommande;
    num? total;

    factory Return.fromJson(Map<String, dynamic> json) => Return(
        idretour: json["idretour"],
        dateRetour: json["date_retour"],
        utilisateur: json["utilisateur"],
        nombreArticle: json["nombre_article"],
        client: json["client"],
        numerocommande: json["numerocommande"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "idretour": idretour,
        "date_retour": dateRetour,
        "utilisateur": utilisateur,
        "nombre_article": nombreArticle,
        "client": client,
        "numerocommande": numerocommande,
        "total": total,
    };
}
