// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';

List<Client> clientFromJson(String str) => List<Client>.from(json.decode(str).map((x) => Client.fromJson(x)));

String clientToJson(List<Client> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Client {
    Client({
      required  this.idclient,
      required  this.nom,
      required  this.prenom,
      required  this.cin,
      required  this.raisonSocial,
      required  this.adresse,
      required  this.telephone,
      required  this.fax,
      required  this.dateInsc,
      required  this.ville,
      required  this.typeClient,
    });

    num? idclient;
    String? nom;
    String? prenom;
    String? cin;
    String? raisonSocial;
    String? adresse;
    String? telephone;
    String? fax;
    String? dateInsc;
    String? ville;
    String? typeClient;

    factory Client.fromJson(Map<String, dynamic> json) => Client(
        idclient: json["idclient"],
        nom: json["nom"],
        prenom: json["prenom"],
        cin: json["cin"],
        raisonSocial: json["raison_social"],
        adresse: json["adresse"],
        telephone: json["telephone"],
        fax: json["fax"],
        dateInsc: json["date_insc"],
        ville: json["ville"],
        typeClient: json["type_client"],
    );

    Map<String, dynamic> toJson() => {
        "idclient": idclient,
        "nom": nom,
        "prenom": prenom,
        "cin": cin,
        "raison_social": raisonSocial,
        "adresse": adresse,
        "telephone": telephone,
        "fax": fax,
        "date_insc": dateInsc,
        "ville": ville,
        "type_client": typeClient,
    };
}