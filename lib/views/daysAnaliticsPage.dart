// ignore_for_file: deprecated_member_use, unnecessary_string_interpolations, sort_child_properties_last, prefer_const_constructors, unnecessary_null_comparison, prefer_if_null_operators, avoid_print

import 'package:librairiedumaroc/views/salesdetailpagefortheday.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
import '../services/Credits.dart';
import '../services/SoldArticles.dart';

class daysAnaliticsPage extends StatefulWidget {
  final DateTime day1;
  final DateTime day2;
  const daysAnaliticsPage({Key? key, required this.day1, required this.day2});

  @override
  State<daysAnaliticsPage> createState() =>
      _daysAnaliticsPageState(day1: day1, day2: day2);
}

class _daysAnaliticsPageState extends State<daysAnaliticsPage> {
  final DateTime day1;
  final DateTime day2;
  _daysAnaliticsPageState({Key? key, required this.day1, required this.day2});
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
  num? salessum;
  num? creditssum;
  num? returnssum;
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
    if (clients != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getCredit() async {
    credits = await Credits().getCredits();
    if (credits != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getReturns() async {
    returns = await Returns().getReturns();
    if (returns != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getReturnedAtricles() async {
    returnedArticles = await ReturnedArticles().getReturnedAtricles();
    if (returnedArticles != null) {
      setState(() {
        isLoaded = true;
      });
    }
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

  late List<DateTime> days;
  updateDates() {
    DateTime startDateAsDate = day1;
    DateTime endDateAsDate = day2;
    DateTime startDateNullCheck() {
      return startDateAsDate == null
          ? DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          : startDateAsDate;
    }

    DateTime endDateNullCheck() {
      return endDateAsDate == null
          ? DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          : endDateAsDate;
    }

    getDaysInBetween() {
      final int difference =
          endDateNullCheck().difference(startDateNullCheck()).inDays + 1;
      return difference;
    }

    days = List<DateTime>.generate(getDaysInBetween(), (i) {
      DateTime date = startDateNullCheck();

      return date.add(Duration(days: i));
    });
  }

  List salesTotals = [];
  List creditsTotals = [];
  List returnsTotals = [];
  Widget dateView() {
    updateDates();
    num periodSalesSum = 0;
    num periodCreditsSum = 0;
    num periodReturnsSum = 0;
    salesTotals.clear();
    creditsTotals.clear();
    returnsTotals.clear();
    for (var day in days) {
      salessum = 0;
      creditssum = 0;
      returnssum = 0;
      salesToday = sales
          ?.where((element) =>
              element.dateVent ==
              '${day.toString().substring(0, 10)}T00:00:00.000Z')
          .toList();
      for (int e = 0; e < salesToday!.length; e++) {
        salessum = salessum! + salesToday![e].totale!;
      }
      creditsToday = credits
          ?.where((element) =>
              element.date ==
              '${day.toString().substring(0, 10)}T00:00:00.000Z')
          .toList();
      for (int e = 0; e < creditsToday!.length; e++) {
        creditssum = creditssum! +
            (creditsToday![e].total == null ? 0 : creditsToday![e].total!);
      }
      returnsToday = returns
          ?.where((element) =>
              element.dateRetour ==
              '${day.toString().substring(0, 10)}T00:00:00.000Z')
          .toList();
      for (int e = 0; e < returnsToday!.length; e++) {
        returnssum = returnssum! + returnsToday![e].total!;
      }
      salesTotals.add(salessum!.toStringAsFixed(2));
      creditsTotals.add(creditssum!.toStringAsFixed(2));
      returnsTotals.add(returnssum!.toStringAsFixed(2));
    }

    for (int e = 0; e < salesTotals.length; e++) {
      periodSalesSum = periodSalesSum + num.parse(salesTotals[e]);
    }
    for (int e = 0; e < creditsTotals.length; e++) {
      periodCreditsSum = periodCreditsSum + num.parse(creditsTotals[e]);
    }
    for (int e = 0; e < returnsTotals.length; e++) {
      periodReturnsSum = periodReturnsSum + num.parse(returnsTotals[e]);
    }

    return Column(
      children: [
        Text("Statistiques des ventes entre",
            style: GoogleFonts.cairo(
                color: const Color(0xff000000),
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        Text(
            "${days[0].day}/${days[0].month}/${days[0].year} et ${days[days.length - 1].day}/${days[days.length - 1].month}/${days[days.length - 1].year}",
            style: GoogleFonts.cairo(
                color: const Color(0xff000000),
                fontWeight: FontWeight.bold,
                fontSize: 15)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      "Vente",
                      style: GoogleFonts.cairo(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Color(0xff00B4DB),
                              Color(0xff0083B0)
                            ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: Center(
                          child: Text(
                            '${periodSalesSum.toStringAsFixed(2)}',
                            style: GoogleFonts.cairo(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Credit",
                      style: GoogleFonts.cairo(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Color(0xff00B4DB),
                              Color(0xff0083B0)
                            ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: Center(
                          child: Text(
                            "${periodCreditsSum.toStringAsFixed(2)}",
                            style: GoogleFonts.cairo(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Retour",
                      style: GoogleFonts.cairo(
                        color: const Color(0xff000000),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        width: 100,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Color(0xff00B4DB),
                              Color(0xff0083B0)
                            ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight)),
                        child: Center(
                          child: Text(
                            "${periodReturnsSum.toStringAsFixed(2)}",
                            style: GoogleFonts.cairo(
                              color: const Color(0xffffffff),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: ListView.builder(
              itemCount: days.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                'Le ${days[index].day}/${days[index].month}/${days[index].year}',
                                style: GoogleFonts.cairo(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15)),
                            RaisedButton(
                              color: Colors.blue,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            salesdetailpagefortheday(
                                              now: DateTime(
                                                      days[index].year,
                                                      days[index].month,
                                                      days[index].day)
                                                  .toString()
                                                  .substring(0, 10),
                                            )));
                              },
                              child: Text("Details",
                                  style: GoogleFonts.cairo(
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "Totale vente : ${salesTotals[index]} DHS",
                                    style: GoogleFonts.cairo(
                                        color: Colors.green[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Text(
                                    "Totale credit : ${creditsTotals[index]} DHS",
                                    style: GoogleFonts.cairo(
                                        color: Colors.red[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                Text(
                                    "Totale retour : ${returnsTotals[index]} DHS",
                                    style: GoogleFonts.cairo(
                                        color: Colors.orange[900],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Caisse (espèces)",
                                  style: GoogleFonts.cairo(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Container(
                                    width: 100,
                                    decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: [
                                          Color(0xff00B4DB),
                                          Color(0xff0083B0)
                                        ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight)),
                                    child: Center(
                                      child: Text(
                                        num.parse(salesTotals[index]) -
                                                    num.parse(creditsTotals[
                                                        index]) -
                                                    num.parse(returnsTotals[
                                                        index]) <
                                                0
                                            ? "0 DH"
                                            : '${(num.parse(salesTotals[index]) - num.parse(creditsTotals[index]) - num.parse(returnsTotals[index])).toStringAsFixed(2)} DHS',
                                        style: GoogleFonts.cairo(
                                          color: const Color(0xffffffff),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerScrimColor: Color(0xff000000),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      body:dateView(),
    );
  }
}
