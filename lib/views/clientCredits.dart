// ignore_for_file: prefer_const_constructors, implementation_imports, unnecessary_import, camel_case_types, deprecated_member_use, unused_element, avoid_print, sized_box_for_whitespace, prefer_if_null_operators, unnecessary_null_comparison, body_might_complete_normally_nullable, unused_local_variable, prefer_is_empty, avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, file_names, prefer_typing_uninitialized_variables, unused_import, no_logic_in_create_state, use_key_in_widget_constructors, await_only_futures
import 'package:flutter/rendering.dart';
import 'package:librairiedumaroc/views/togglebar.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
import 'salePage.dart';

class clientCredits extends StatefulWidget {
  final String client;
  const clientCredits({Key? key, required this.client});

  @override
  State<clientCredits> createState() => _clientCreditsState(client: client);
}

class _clientCreditsState extends State<clientCredits> {
  final String client;
  _clientCreditsState({Key? key, required this.client});
  List<Sale>? sales;
  List<Sale>? creditedSale;
  List<SoldArticle>? soldarticles;
  List<SoldArticle>? soldarticlesNum;
  List<Article>? articles;
  List<Client>? clients;
  List<Credit>? credits;
  List<Credit> creditedClient = [];
  List<Return>? returns;
  List<ReturnedArticle>? returnedArticles;
  List<ReturnedArticle>? returnedArticlesNum;
  num totalSum = 0;
  num avanceSum = 0;
  num restSum = 0;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from api
    getData();
  }

  getData() async {
    sales = await Sales().getSales();
    soldarticles = await SoldArticles().getSoldArticles();
    articles = await Articles().getArticles();
    clients = await Clients().getClients();
    credits = await Credits().getCredits();
    returns = await Returns().getReturns();
    returnedArticles = await ReturnedArticles().getReturnedAtricles();
    creditedClient =
        credits!.where((element) => element.client == client).toList();
    for (var clientCredited in creditedClient) {
      clientCredited.total == null
          ? totalSum += 0
          : totalSum += clientCredited.total!;
      clientCredited.avance == null
          ? avanceSum += 0
          : avanceSum += clientCredited.avance!;
      // clientCredited.rest == null
      //     ? restSum += 0
      //     : restSum += clientCredited.rest!;
    }
    restSum = totalSum - avanceSum;
    if (sales != null &&
        soldarticles != null &&
        articles != null &&
        clients != null &&
        credits != null &&
        returns != null &&
        returnedArticles != null &&
        creditedClient != null) {
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

  getCreditedSale(String? num) {
    creditedSale =
        sales!.where((element) => element.numeroCommande == num).toList();
  }

  String? startDate;
  String? endDate;

  _onSelectedChanged(
      DateRangePickerSelectionChangedArgs
          dateRangePickerSelectionChangedArgs) async {
    PickerDateRange dateRange = await dateRangePickerSelectionChangedArgs.value;
    startDate = dateRange.toString().split(",")[0];
    endDate = dateRange.toString().split(",")[1];
  }

  late List<DateTime> days;
  updateDates(DateTime startDateAsDate, DateTime endDateAsDate) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: Center(child: CircularProgressIndicator()),
        child: Container(
          child: Column(
            children: [
              Center(
                child: Text("$client",
                    style: GoogleFonts.cairo(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 30)),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("Total",
                              style: GoogleFonts.cairo(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: const [
                                    Color(0xff00B4DB),
                                    Color(0xff0083B0)
                                  ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight)),
                              child: Center(
                                child: Text(
                                  "${totalSum.toStringAsFixed(2)}",
                                  style: GoogleFonts.cairo(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Avance",
                              style: GoogleFonts.cairo(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: const [
                                    Color(0xff00B4DB),
                                    Color(0xff0083B0)
                                  ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight)),
                              child: Center(
                                child: Text(
                                  "${avanceSum.toStringAsFixed(2)}",
                                  style: GoogleFonts.cairo(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Rest",
                              style: GoogleFonts.cairo(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: const [
                                    Color(0xff00B4DB),
                                    Color(0xff0083B0)
                                  ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight)),
                              child: Center(
                                child: Text(
                                  "${restSum.toStringAsFixed(2)}",
                                  style: GoogleFonts.cairo(
                                    color: Color(0xffffffff),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),
              )),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Container(
                    color: Color(0xfff4a261),
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (var clientCredited in creditedClient)
                                clientCredited.numeroCommande == null
                                    ? Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Card(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Date : ${clientCredited.date.toString().substring(0, 10)}",
                                                            style: GoogleFonts
                                                                .cairo(
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Text(
                                                            "Type : Reglement credit",
                                                            style: GoogleFonts
                                                                .cairo(
                                                              color: Color(
                                                                  0xff000000),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Montant de reglement :",
                                                                  style:
                                                                      GoogleFonts
                                                                          .cairo(
                                                                    color: Color(
                                                                        0xff000000),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  )),
                                                              SizedBox(
                                                                width: 2.5,
                                                              ),
                                                              ClipRRect(
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            20)),
                                                                child:
                                                                    Container(
                                                                  width: 100,
                                                                  decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                          colors: const [
                                                                        Color(
                                                                            0xff00B4DB),
                                                                        Color(
                                                                            0xff0083B0)
                                                                      ],
                                                                          begin: Alignment
                                                                              .topLeft,
                                                                          end: Alignment
                                                                              .bottomRight)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      clientCredited.avance ==
                                                                              null
                                                                          ? "Null"
                                                                          : "${clientCredited.avance!.toStringAsFixed(2)}",
                                                                      style: GoogleFonts
                                                                          .cairo(
                                                                        color: Color(
                                                                            0xffffffff),
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ))
                                    : Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Date : ${clientCredited.date.toString().substring(0, 10)}",
                                                          style:
                                                              GoogleFonts.cairo(
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Commande № : ${clientCredited.numeroCommande.toString()}",
                                                          style:
                                                              GoogleFonts.cairo(
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          "Utilisateur : ${clientCredited.utilisateur.toString()}",
                                                          style:
                                                              GoogleFonts.cairo(
                                                            color: Color(
                                                                0xff000000),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          clientCredited
                                                                      .numeroCommande ==
                                                                  null
                                                              ? showDialog(
                                                                  context:
                                                                      context,
                                                                  barrierDismissible:
                                                                      true,
                                                                  builder: (BuildContext
                                                                          buildContext) =>
                                                                      AlertDialog(
                                                                        actions: [
                                                                          ElevatedButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text("annuler", style: GoogleFonts.cairo(color: Color(0xffffffff), fontWeight: FontWeight.bold, fontSize: 20)))
                                                                        ],
                                                                        content: Text(
                                                                            "Le numero de commande est null",
                                                                            style: GoogleFonts.cairo(
                                                                                color: Color(0xffffffff),
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20)),
                                                                        backgroundColor:
                                                                            Colors.blue[900],
                                                                      ))
                                                              : Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => salePage(
                                                                          num: clientCredited
                                                                              .numeroCommande
                                                                              .toString())));
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff023047)),
                                                        child: Text(
                                                          "DETAILS",
                                                          style:
                                                              GoogleFonts.cairo(
                                                            color: Color(
                                                                0xffffffff),
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text("Total",
                                                              style: GoogleFonts.cairo(
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            child: Container(
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      colors: const [
                                                                    Color(
                                                                        0xff00B4DB),
                                                                    Color(
                                                                        0xff0083B0)
                                                                  ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight)),
                                                              child: Center(
                                                                child: Text(
                                                                  clientCredited
                                                                              .total ==
                                                                          null
                                                                      ? "Null"
                                                                      : "${clientCredited.total!.toStringAsFixed(2)}",
                                                                  style:
                                                                      GoogleFonts
                                                                          .cairo(
                                                                    color: Color(
                                                                        0xffffffff),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text("Avance",
                                                              style: GoogleFonts.cairo(
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            child: Container(
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      colors: const [
                                                                    Color(
                                                                        0xff00B4DB),
                                                                    Color(
                                                                        0xff0083B0)
                                                                  ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight)),
                                                              child: Center(
                                                                child: Text(
                                                                  clientCredited
                                                                              .avance ==
                                                                          null
                                                                      ? "Null"
                                                                      : "${clientCredited.avance!.toStringAsFixed(2)}",
                                                                  style:
                                                                      GoogleFonts
                                                                          .cairo(
                                                                    color: Color(
                                                                        0xffffffff),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text("Rest",
                                                              style: GoogleFonts.cairo(
                                                                  color: Color(
                                                                      0xff000000),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                          ClipRRect(
                                                            borderRadius:
                                                                const BorderRadius
                                                                        .all(
                                                                    Radius
                                                                        .circular(
                                                                            20)),
                                                            child: Container(
                                                              width: 100,
                                                              decoration: BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      colors: const [
                                                                    Color(
                                                                        0xff00B4DB),
                                                                    Color(
                                                                        0xff0083B0)
                                                                  ],
                                                                      begin: Alignment
                                                                          .topLeft,
                                                                      end: Alignment
                                                                          .bottomRight)),
                                                              child: Center(
                                                                child: Text(
                                                                  clientCredited
                                                                              .rest ==
                                                                          null
                                                                      ? "Null"
                                                                      : "${clientCredited.rest!.toStringAsFixed(2)}",
                                                                  // : "${(clientCredited.total! - clientCredited.avance!).toStringAsFixed(2)}",
                                                                  style:
                                                                      GoogleFonts
                                                                          .cairo(
                                                                    color: Color(
                                                                        0xffffffff),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ])
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                            ],
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
