// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, must_call_super, sort_child_properties_last, unused_import, unused_local_variable, avoid_print, prefer_const_literals_to_create_immutables, duplicate_import, deprecated_member_use, body_might_complete_normally_nullable, sized_box_for_whitespace, unrelated_type_equality_checks, prefer_is_empty

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:librairiedumaroc/main.dart';
import 'package:librairiedumaroc/model/article.dart';
import 'package:librairiedumaroc/model/client.dart';
import 'package:librairiedumaroc/model/credit.dart';
import 'package:librairiedumaroc/model/return.dart';
import 'package:librairiedumaroc/model/returnedArticle.dart';
import 'package:librairiedumaroc/model/sale.dart';
import 'package:librairiedumaroc/model/soldArticle.dart';
import 'package:librairiedumaroc/services/Articles.dart';
import 'package:librairiedumaroc/services/Clients.dart';
import 'package:librairiedumaroc/services/ReturnedArticles.dart';
import 'package:librairiedumaroc/services/Returns.dart';
import 'package:librairiedumaroc/services/Sales.dart';
import 'package:librairiedumaroc/views/navBar.dart';
import '../services/Credits.dart';
import '../services/SoldArticles.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class clientsPage extends StatefulWidget {
  const clientsPage({Key? key}) : super(key: key);

  @override
  State<clientsPage> createState() => _clientsPageState();
}

class _clientsPageState extends State<clientsPage> {
  DateTime datetime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  List<Sale>? sales;
  List<Sale>? salesToday;
  List<SoldArticle>? soldarticles;
  List<SoldArticle>? soldarticlesNum;
  List<Article>? articles;
  List<Client>? clients;
  List<Credit>? credits;
  List<Credit>? creditsToday;
  List<Return>? returns;
  List<Return>? returnsToday;
  List<ReturnedArticle>? returnedArticles;
  List<ReturnedArticle>? returnedArticlesNum;
  num salessum = 0;
  num creditssum = 0;
  num returnssum = 0;
  num registryTotal = 0;
  num returnlength = 0;
  String? now;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from api
    getSale();
    getSoldArticle();
    getArticle();
    getClient();
    getCredit();
    getReturns();
    getReturnedAtricles();
  }

  getSale() async {
    sales = await Sales().getSales();
    now = datetime.toString().substring(0, 10);
    salesToday = sales
        ?.where((element) => element.dateVent == '${now}T00:00:00.000Z')
        .toList();
    for (int e = 0; e < salesToday!.length; e++) {
      salessum += salesToday![e].totale!;
    }
    if (sales != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getSoldArticle() async {
    soldarticles = await SoldArticles().getSoldArticles();
    if (soldarticles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getArticle() async {
    articles = await Articles().getArticles();
    if (articles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getClient() async {
    clients = await Clients().getClients();
    if (articles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getCredit() async {
    credits = await Credits().getCredits();
    now = datetime.toString().substring(0, 10);
    creditsToday = credits
        ?.where((element) => element.date == '${now}T00:00:00.000Z')
        .toList();
    for (int e = 0; e < creditsToday!.length; e++) {
      creditssum += creditsToday![e].total!;
    }
    if (articles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getReturns() async {
    returns = await Returns().getReturns();
    now = datetime.toString().substring(0, 10);
    returnsToday = returns
        ?.where((element) => element.dateRetour == '${now}T00:00:00.000Z')
        .toList();
    for (int e = 0; e < returnsToday!.length; e++) {
      returnssum += returnsToday![e].total!;
    }
    returnlength = returnsToday!.length;
    if (articles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getReturnedAtricles() async {
    returnedArticles = await ReturnedArticles().getReturnedAtricles();
    if (articles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Les clients',
            style: GoogleFonts.cairo(
                color: Color(0xff000000),
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Container(
              child: Center(
                  child: ElevatedButton(
                child: Text(
                  "click here",
                  style: GoogleFonts.cairo(
                      color: Color(0xff000000),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                onPressed: () {
                  List<Client> clientsName = clients!.toSet().toList();
                  for (var client in clients!.map((e) => e.nom).toSet().toList()) {
                    print(client!.length);
                  }
                },
              )),
            )));
  }
}
