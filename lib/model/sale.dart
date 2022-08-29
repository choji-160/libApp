// To parse this JSON data, do
//
    // final sale = saleFromJson(jsonString);

import 'dart:convert';

List<Sale> saleFromJson(String str) => List<Sale>.from(json.decode(str).map((x) => Sale.fromJson(x)));

String saleToJson(List<Sale> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sale {
    Sale({
        required this.idvente,
        required this.dateVent,
        required this.utilisateur,
        required this.nombreArticle,
        required this.client,
        required this.numeroCommande,
        required this.totale,
        required this.mPaiement,
        required this.type,
    });

    num? idvente;
    String? dateVent;
    String?  utilisateur;
    String? nombreArticle;
    String? client;
    String? numeroCommande;
    num? totale;
    String? mPaiement;
    String? type;

    factory Sale.fromJson(Map<String, dynamic> json) => Sale(
        idvente: json["idvente"],
        dateVent: json["date_vent"],
        utilisateur: json["utilisateur"],
        nombreArticle: json["nombre_article"],
        client: json["client"],
        numeroCommande: json["numero_commande"],
        totale: json["totale"],
        mPaiement: json["M_paiement"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "idvente": idvente,
        "date_vent": dateVent,
        "utilisateur": utilisateur,
        "nombre_article": nombreArticle,
        "client": client,
        "numero_commande": numeroCommande,
        "totale": totale,
        "M_paiement": mPaiement,
        "type": type,
    };
}