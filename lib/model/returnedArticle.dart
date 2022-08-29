// To parse this JSON data, do
//
//     final returnedArticle = returnedArticleFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

List<ReturnedArticle> returnedArticleFromJson(String str) => List<ReturnedArticle>.from(json.decode(str).map((x) => ReturnedArticle.fromJson(x)));

String returnedArticleToJson(List<ReturnedArticle> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReturnedArticle {
    ReturnedArticle({
      required this.idretourArticle,
      required this.dateRetourArticle,
      required this.numeroCommande,
      required this.code,
      required this.designation,
      required this.quantite,
      required this.prix,
      required this.remise,
      required this.total,
      required this.tva,
    });

    num? idretourArticle;
    String? dateRetourArticle;
    String? numeroCommande;
    String? code;
    String? designation;
    num? quantite;
    num? prix;
    num? remise;
    num? total;
    String? tva;

    factory ReturnedArticle.fromJson(Map<String, dynamic> json) => ReturnedArticle(
        idretourArticle: json["idretour_article"],
        dateRetourArticle: json["date_retour_article"],
        numeroCommande: json["numero_commande"],
        code: json["code"],
        designation: json["designation"],
        quantite: json["quantite"],
        prix: json["prix"],
        remise: json["remise"],
        total: json["total"],
        tva: json["tva"],
    );

    Map<String, dynamic> toJson() => {
        "idretour_article": idretourArticle,
        "date_retour_article": dateRetourArticle,
        "numero_commande": numeroCommande,
        "code": code,
        "designation": designation,
        "quantite": quantite,
        "prix": prix,
        "remise": remise,
        "total": total,
        "tva": tva,
    };
}
