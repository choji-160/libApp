// To parse this JSON data, do
//
//     final SoldArticle = SoldArticleFromJson(jsonString);

// ignore_for_file: unnecessary_new, unnecessary_null_comparison, prefer_conditional_assignment, constant_identifier_names, non_constant_identifier_names

import 'dart:convert';

List<SoldArticle> SoldArticleFromJson(String str) => List<SoldArticle>.from(json.decode(str).map((x) => SoldArticle.fromJson(x)));

String SoldArticleToJson(List<SoldArticle> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SoldArticle {
    SoldArticle({
      required  this.idventeArticle,
      required  this.dateVentArticle,
      required  this.numeroCommande,
      required  this.code,
      required  this.designation,
      required  this.quantite,
      required  this.prix,
      required  this.remise,
      required  this.total,
      required  this.tva,
      required  this.type,
    });

    num? idventeArticle;
    String? dateVentArticle;
    String? numeroCommande;
    String? code;
    String? designation;
    num? quantite;
    num? prix;
    num? remise;
    num? total;
    String? tva;
    String? type;

    factory SoldArticle.fromJson(Map<String, dynamic> json) => SoldArticle(
        idventeArticle: json["idvente_article"],
        dateVentArticle: json["date_vent_article"],
        numeroCommande: json["numero_commande"],
        code: json["code"],
        designation: json["designation"],
        quantite: json["quantite"],
        prix: json["prix"],
        remise: json["remise"],
        total: json["total"],
        tva: json["tva"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "idvente_article": idventeArticle,
        "date_vent_article": dateVentArticle.toString(),
        "numero_commande": numeroCommande,
        "code": code,
        "designation": designation,
        "quantite": quantite,
        "prix": prix,
        "remise": remise,
        "total": total,
        "tva": tva,
        "type": type,
    };
}
