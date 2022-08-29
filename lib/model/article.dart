// To parse this JSON data, do
//
//     final article = articleFromJson(jsonString);

import 'dart:convert';

List<Article> articleFromJson(String str) => List<Article>.from(json.decode(str).map((x) => Article.fromJson(x)));

String articleToJson(List<Article> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Article {
    Article({
      required  this.idarticle,
      required  this.designation,
      required  this.codeBarre,
      required  this.prixAchat,
      required  this.prixVent,
      required  this.quantit,
      required  this.remise,
      required  this.fournisseur,
      required  this.datee,
      required  this.quantiteMin,
      required  this.codeBarreP,
      required  this.familleProduit,
    });

    num? idarticle;
    String? designation;
    String? codeBarre;
    num? prixAchat;
    num? prixVent;
    num? quantit;
    num? remise;
    String? fournisseur;
    String? datee;
    num? quantiteMin;
    String? codeBarreP;
    String? familleProduit;

    factory Article.fromJson(Map<String, dynamic> json) => Article(
        idarticle: json["idarticle"],
        designation: json["designation"],
        codeBarre: json["code_barre"],
        prixAchat: json["prix_achat"],
        prixVent: json["prix_vent"],
        quantit: json["quantité"],
        remise: json["remise"],
        fournisseur: json["fournisseur"],
        datee: json["datee"],
        quantiteMin: json["quantite_min"],
        codeBarreP: json["code_barre_p"],
        familleProduit: json["famille_produit"],
    );

    Map<String, dynamic> toJson() => {
        "idarticle": idarticle,
        "designation": designation,
        "code_barre": codeBarre,
        "prix_achat": prixAchat,
        "prix_vent": prixVent,
        "quantité": quantit,
        "remise": remise,
        "fournisseur": fournisseur,
        "datee": datee,
        "quantite_min": quantiteMin,
        "code_barre_p": codeBarreP,
        "famille_produit": familleProduit,
    };
}