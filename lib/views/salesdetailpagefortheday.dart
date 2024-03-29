// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, must_call_super, sort_child_properties_last, unused_import, unused_local_variable, avoid_print, prefer_const_literals_to_create_immutables, duplicate_import, deprecated_member_use, body_might_complete_normally_nullable, sized_box_for_whitespace, unrelated_type_equality_checks, prefer_is_empty, camel_case_types, unused_element, no_logic_in_create_state, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

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
import 'package:librairiedumaroc/views/salePage.dart';
import '../api/pdf_api.dart';
import '../services/Credits.dart';
import '../services/SoldArticles.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class salesdetailpagefortheday extends StatefulWidget {
  final String now;
  salesdetailpagefortheday({Key? key, required this.now});

  @override
  State<salesdetailpagefortheday> createState() =>
      _salesdetailpageforthedayState(now: now);
}

class _salesdetailpageforthedayState extends State<salesdetailpagefortheday> {
  final String now;
  _salesdetailpageforthedayState({Key? key, required this.now});
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
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from api
    getData();
    getRegistryTotal();
  }

  getData() async {
    sales = await Sales().getSales();
    soldarticles = await SoldArticles().getSoldArticles();
    articles = await Articles().getArticles();
    clients = await Clients().getClients();
    credits = await Credits().getCredits();
    returns = await Returns().getReturns();
    returnedArticles = await ReturnedArticles().getReturnedAtricles();
    salesToday = sales
        ?.where((element) => element.dateVent == '${now}T00:00:00.000Z')
        .toList();
    creditsToday = credits
        ?.where((element) => element.date == '${now}T00:00:00.000Z')
        .toList();
    returnsToday = returns
        ?.where((element) => element.dateRetour == '${now}T00:00:00.000Z')
        .toList();
    salessum = 0;
    for (int e = 0; e < salesToday!.length; e++) {
      salessum += salesToday![e].totale!;
    }
    creditssum = 0;
    for (int e = 0; e < creditsToday!.length; e++) {
      creditssum += creditsToday![e].total == null ? 0 : creditsToday![e].total!;
    }
    returnssum = 0;
    for (int e = 0; e < returnsToday!.length; e++) {
      returnssum += returnsToday![e].total!;
    }
    returnlength = returnsToday!.length;

    if (sales != null &&
        salesToday != null &&
        soldarticles != null &&
        articles != null &&
        clients != null &&
        credits != null &&
        creditsToday != null &&
        returns != null &&
        returnsToday != null &&
        returnedArticles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }
  Text? getRegistryTotal() {
    num regTotal = salessum - creditssum - returnssum;
    getRegTotal() {
      if (regTotal < 0) {
        return Text(
          '0 DHS',
          style: GoogleFonts.cairo(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
          ),
        );
      } else if (regTotal >= 0) {
        return Text(
          '${(salessum - creditssum - returnssum).toStringAsFixed(2)} DHS',
          style: GoogleFonts.cairo(
            color: Color(0xffffffff),
            fontWeight: FontWeight.bold,
          ),
        );
      }
    }

    return getRegTotal();
  }

  getSoldArticlesNum(String? num) {
    soldarticlesNum = soldarticles
        ?.where((element) => element.numeroCommande == num)
        .toList();
  }

  getReturnedArticlesNum(String? num) {
    returnedArticlesNum = returnedArticles
        ?.where((element) => element.numeroCommande == num)
        .toList();
  }

  Widget? returnDetails(index, context) {
    getReturnedArticlesNum(returnsToday![index].numerocommande);
    showModalBottomSheet(
        backgroundColor: Color(0xfff4a261),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        context: context,
        builder: (BuildContext buildcontext) {
          return Container(
            height: 600,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            "Informations générales sur le retour : ${returnsToday![index].numerocommande.toString()}",
                            style: GoogleFonts.cairo(
                              color: Color(0xff000000),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Client : ${returnsToday![index].client.toString()}",
                                    style: GoogleFonts.cairo(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Utilisateur: ${returnsToday![index].utilisateur.toString()}",
                                    style: GoogleFonts.cairo(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "Nombre articles : ${returnsToday![index].nombreArticle.toString()}",
                                    style: GoogleFonts.cairo(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Totale : ${returnsToday![index].total.toString()}",
                                    style: GoogleFonts.cairo(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15)),
                    child: Container(
                      color: Color(0xff05668d),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: returnedArticlesNum?.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Designation : ${returnedArticlesNum![index].designation}",
                                        style: GoogleFonts.cairo(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Quantité : ${returnedArticlesNum![index].quantite}",
                                        style: GoogleFonts.cairo(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Prix : ${returnedArticlesNum![index].prix}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Remise : ${returnedArticlesNum![index].remise}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Totale : ${returnedArticlesNum![index].total}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "TVA : ${returnedArticlesNum![index].tva}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  returnsListView() {
    showModalBottomSheet(
        backgroundColor: Color(0xfff4a261),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        context: context,
        builder: (BuildContext buildcontext) {
          return Container(
            height: 600,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: [
                  Icon(
                    Icons.drag_handle,
                    color: Colors.white,
                    size: 30,
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: returnsToday?.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Commande № : ${returnsToday![index].numerocommande.toString()}",
                                          style: GoogleFonts.cairo(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Client : ${returnsToday![index].client.toString()}",
                                          style: GoogleFonts.cairo(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              returnDetails(index, context);
                                            },
                                            child: Text(
                                              "DETAILS",
                                              style: GoogleFonts.cairo(
                                                color: Color(0xffffffff),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Color(0xff023047)),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Nombre articles : ${returnsToday![index].nombreArticle.toString()}",
                                          style: GoogleFonts.cairo(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Totale : ${returnsToday![index].total.toString()}",
                                          style: GoogleFonts.cairo(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Utilisateur : ${returnsToday![index].utilisateur.toString()}",
                                          style: GoogleFonts.cairo(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget homePageData() {
    return Visibility(
      visible: isLoaded,
      replacement: const Center(
        child: CircularProgressIndicator(),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Les Statistiques du ($now)",
              style: GoogleFonts.cairo(
                  color: Color(0xff000000),
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 170,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "Ventes",
                                  style: GoogleFonts.cairo(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "${salessum.toStringAsFixed(2)} DHS",
                                  style: GoogleFonts.cairo(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xff00B4DB), Color(0xff0083B0)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                      ),
                    ),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 170,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      "Retours",
                                      style: GoogleFonts.cairo(
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Text(
                                      "${returnssum.toStringAsFixed(2)} DHS",
                                      style: GoogleFonts.cairo(
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                child: returnlength == 0
                                    ? Container()
                                    : IconButton(
                                        onPressed: () {
                                          returnsListView();
                                        },
                                        icon: Icon(Icons.info_rounded),
                                        color: Color(0xff000000),
                                      ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xffb84fce), Color(0xffd4acfb)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 170,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "Credits",
                                  style: GoogleFonts.cairo(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "${creditssum.toStringAsFixed(2)} DHS",
                                  style: GoogleFonts.cairo(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xffED213A), Color(0xff93291E)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                      ),
                    ),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        width: 170,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  "Caisse (espèces)",
                                  style: GoogleFonts.cairo(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: getRegistryTotal(),
                              )
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xfffc4a1a), Color(0xfff7b733)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Le totale des ventes d'aujourd'hui est : ${salesToday?.length}",
            style: GoogleFonts.cairo(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: Container(
                color: Color(0xfff4a261),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: salesToday?.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Client : ${salesToday![index].client.toString()}",
                                        style: GoogleFonts.cairo(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Commande № : ${salesToday![index].numeroCommande.toString()}",
                                        style: GoogleFonts.cairo(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "M_paiement : ${salesToday![index].mPaiement.toString()}",
                                        style: GoogleFonts.cairo(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        salePage(
                                                            num: salesToday![
                                                                    index]
                                                                .numeroCommande
                                                                .toString())));
                                          },
                                          child: Text(
                                            "DETAILS",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff023047)),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Nombre articles : ${salesToday![index].nombreArticle.toString()}",
                                        style: GoogleFonts.cairo(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Totale : ${salesToday![index].totale.toString()}",
                                        style: GoogleFonts.cairo(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Type : ${salesToday![index].type.toString().substring(0, 2)}",
                                        style: GoogleFonts.cairo(
                                          color: Color(0xff000000),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerScrimColor: Color(0xff000000),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            now,
            style: GoogleFonts.cairo(
                color: Color(0xff000000),
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: homePageData());
  }
}
