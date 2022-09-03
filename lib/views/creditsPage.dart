// ignore_for_file: prefer_const_constructors, implementation_imports, unnecessary_import, camel_case_types, deprecated_member_use, unused_element, avoid_print, sized_box_for_whitespace, prefer_if_null_operators, unnecessary_null_comparison, body_might_complete_normally_nullable, unused_local_variable, prefer_is_empty, avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, file_names, prefer_typing_uninitialized_variables
import 'package:flutter/rendering.dart';
import 'package:librairiedumaroc/views/clientCredits.dart';
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

class creditsPage extends StatefulWidget {
  const creditsPage({Key? key}) : super(key: key);

  @override
  State<creditsPage> createState() => _creditsPageState();
}

class _creditsPageState extends State<creditsPage> {
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
  num? salessum;
  num? creditssum;
  num? returnssum;
  List<String> searchWith = ["Date et N.Commande", "Nom Client"];
  int counter = 0;
  var isLoaded = false;
  List creditedClients = [];
  List results = [];

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
    if (articles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getCredit() async {
    credits = await Credits().getCredits();
    for (var client in credits!) {
      bool exists = false;
      for (var creditedClient in creditedClients) {
        if (client.client == creditedClient) {
          exists = true;
        }
      }
      if (!exists) {
        creditedClients.add(client.client);
      }
    }

    for (var client in credits!) {
      bool exists = false;
      for (var result in results) {
        if (client.client == result) {
          exists = true;
        }
      }
      if (!exists) {
        results.add(client.client);
      }
    }
    if (articles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getReturns() async {
    returns = await Returns().getReturns();
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

  final commandNumberController = TextEditingController();
  final clientNameController = TextEditingController();
  Widget? creditDetail(String num) {
    getSoldArticlesNum(num);
    List<Sale> commandeSale =
        sales!.where(((saleNum) => saleNum.numeroCommande == num)).toList();
    List<Credit> commandeCredit =
        credits!.where((creditNum) => creditNum.numeroCommande == num).toList();
    commandeCredit.length == 0
        ? showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext buildContext) => AlertDialog(
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("annuler",
                            style: GoogleFonts.cairo(
                                color: Color(0xffffffff),
                                fontWeight: FontWeight.bold,
                                fontSize: 20)))
                  ],
                  content: Text("vérifier le numéro de commande",
                      style: GoogleFonts.cairo(
                          color: Color(0xffffffff),
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                  backgroundColor: Colors.blue[900],
                ))
        : showModalBottomSheet(
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
                                "Informations générales sur le Credit : $num",
                                style: GoogleFonts.cairo(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Date : ${commandeSale[0].dateVent.toString().substring(0, 10)}",
                                style: GoogleFonts.cairo(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                      "Totale : ${commandeCredit[0].total!.toStringAsFixed(2)}",
                                      style: GoogleFonts.cairo(
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(
                                      "Avance : ${commandeCredit[0].avance!.toStringAsFixed(2)}",
                                      style: GoogleFonts.cairo(
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(
                                      "Reste :${commandeCredit[0].rest!.toStringAsFixed(2)}",
                                      style: GoogleFonts.cairo(
                                        color: Color(0xff000000),
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Client : ${commandeSale[0].client.toString()}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Utilisateur: ${commandeSale[0].utilisateur.toString()}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "M_paiement : ${commandeSale[0].mPaiement.toString()}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Nombre articles : ${commandeSale[0].nombreArticle.toString()}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Totale : ${commandeSale[0].totale.toString()}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "Type : ${commandeSale[0].type.toString().substring(0, 2)}",
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
                              itemCount: soldarticlesNum?.length,
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
                                            "Designation : ${soldarticlesNum![index].designation}",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "Quantité : ${soldarticlesNum![index].quantite}",
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
                                                "Prix : ${soldarticlesNum![index].prix}",
                                                style: GoogleFonts.cairo(
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Remise : ${soldarticlesNum![index].remise}",
                                                style: GoogleFonts.cairo(
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "Totale : ${soldarticlesNum![index].total}",
                                                style: GoogleFonts.cairo(
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                "TVA : ${soldarticlesNum![index].tva}",
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

  getCreditPerDay() {
    updateDates(DateTime.parse(startDate!.substring(33, 43)),
        DateTime.parse(endDate!.substring(10, 20)));
    List creditsTotals = [];
    num periodCreditsSum = 0;
    creditsTotals.clear();
    for (var day in days) {
      creditssum = 0;
      creditsToday = credits
          ?.where((element) =>
              element.date ==
              '${day.toString().substring(0, 10)}T00:00:00.000Z')
          .toList();
      for (int e = 0; e < creditsToday!.length; e++) {
        creditssum = creditssum! +
            (creditsToday![e].total == null ? 0 : creditsToday![e].total!);
      }
      creditsTotals.add(creditssum!.toStringAsFixed(2));
    }

    for (int e = 0; e < creditsTotals.length; e++) {
      periodCreditsSum = periodCreditsSum + num.parse(creditsTotals[e]);
    }

    List<Credit>? creditsForTheDay;

    creditsFor(DateTime day) {
      creditsForTheDay = credits
          ?.where((element) =>
              element.date ==
              '${day.toString().substring(0, 10)}T00:00:00.000Z')
          .toList();
      return creditsForTheDay;
    }

    Widget? saleDetails(String num) {
      getSoldArticlesNum(num);
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
                  Icon(
                    Icons.drag_handle_sharp,
                    color: Colors.white,
                    size: 30,
                  ),
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
                            itemCount: soldarticlesNum?.length,
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
                                          "Designation : ${soldarticlesNum![index].designation}",
                                          style: GoogleFonts.cairo(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          "Quantité : ${soldarticlesNum![index].quantite}",
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
                                              "Prix : ${soldarticlesNum![index].prix}",
                                              style: GoogleFonts.cairo(
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Remise : ${soldarticlesNum![index].remise}",
                                              style: GoogleFonts.cairo(
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "Totale : ${soldarticlesNum![index].total}",
                                              style: GoogleFonts.cairo(
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "TVA : ${soldarticlesNum![index].tva}",
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

    Widget? dayDetails() {
      return Expanded(
        flex: 1,
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var day in days)
                creditsFor(day)!.isEmpty == true
                    ? Container(
                        height: 0,
                        width: 0,
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          child: Container(
                              color: Color(0xff219ebc),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(15, 8, 15, 8),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            "Le ${day.toString().substring(0, 10)}",
                                            style: GoogleFonts.cairo(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                        Text(
                                            "Le totale des credit est ${creditsForTheDay!.length}",
                                            style: GoogleFonts.cairo(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15)),
                                      ],
                                    ),
                                    for (var creditToday in creditsForTheDay!)
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                            child: Container(
                                              color: Color(0xff023047),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Text(
                                                              creditToday.total ==
                                                                      null
                                                                  ? "Totale : 0"
                                                                  : "Totale ${creditToday.total!.toStringAsFixed(2)}",
                                                              style: GoogleFonts.cairo(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                          Text(
                                                              creditToday.avance ==
                                                                      null
                                                                  ? "Avance : 0"
                                                                  : "Avance ${creditToday.avance!.toStringAsFixed(2)}",
                                                              style: GoogleFonts.cairo(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                          Text(
                                                              creditToday.rest ==
                                                                      null
                                                                  ? "Reste : 0"
                                                                  : "Reste ${creditToday.rest!.toStringAsFixed(2)}",
                                                              style: GoogleFonts.cairo(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      15)),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
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
                                                                  "Client : ${creditToday.client}",
                                                                  style: GoogleFonts.cairo(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                              SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                  "N.Commande : ${creditToday.numeroCommande}",
                                                                  style: GoogleFonts.cairo(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15))
                                                            ],
                                                          ),
                                                          RaisedButton(
                                                              color: Color(
                                                                  0xff6b9080),
                                                              child: Text(
                                                                  "Details",
                                                                  style: GoogleFonts.cairo(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15)),
                                                              onPressed: () {
                                                                saleDetails(
                                                                    creditToday
                                                                        .numeroCommande!);
                                                              })
                                                        ],
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ))
                                  ],
                                ),
                              )),
                        ),
                      )
            ],
          ),
        ),
      );
    }

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Totale des credits entre ${days[0].day}/${days[0].month}/${days[0].year} et ${days[days.length - 1].day}/${days[days.length - 1].month}/${days[days.length - 1].year}",
                              style: GoogleFonts.cairo(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
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
                                  "${periodCreditsSum.toStringAsFixed(2)}",
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
                    ],
                  ),
                ),
                dayDetails()!
              ],
            ),
          );
        });
  }

  Widget creditedClientsList() {
    Widget totalsAccordingToClient(String name) {
      num totalSum = 0;
      num avanceSum = 0;
      num restSum = 0;
      List<Credit> creditedClient =
          credits!.where((element) => element.client == name).toList();
      for (var num in creditedClient) {
        num.total == null ? totalSum += 0 : totalSum += num.total!;
        num.avance == null ? avanceSum += 0 : avanceSum += num.avance!;
        num.rest == null ? restSum += 0 : restSum += num.rest!;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Total : ${totalSum.toStringAsFixed(2)} ",
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          Text("Avance : ${avanceSum.toStringAsFixed(2)} ",
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
          Text("Rest : ${restSum.toStringAsFixed(2)}",
              style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15))
        ],
      );
    }

    return Expanded(
      flex: 1,
      child: Container(
          child: ListView.builder(
              itemCount: creditedClients.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        color: Color(0xff2f3e46),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Client : ${creditedClients[index]}",
                                      style: GoogleFonts.cairo(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  RaisedButton(
                                      color: Color(0xff6b9080),
                                      child: Text("Details",
                                          style: GoogleFonts.cairo(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    clientCredits(client:creditedClients[index])));
                                      })
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              totalsAccordingToClient(creditedClients[index])
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }

  void searchClient(String value) {
    setState(() {
      creditedClients = results;
    });
    final suggestions = creditedClients.where((element) {
      final clientName = element.toString().toLowerCase();
      final input = value.toLowerCase();
      return clientName.contains(input);
    }).toList();
    setState(() => creditedClients = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Les credits',
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
          replacement: Center(
            child: CircularProgressIndicator(),
          ),
          child: Center(
            child: Visibility(
                visible: isLoaded,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: Column(
                  children: [
                    ToggleBar(
                        labels: searchWith,
                        textColor: Colors.black,
                        selectedTextColor: Colors.white,
                        onSelectionUpdated: (index) {
                          setState(() {
                            counter = index;
                          });
                        }),
                    searchWith[counter] == "Date et N.Commande"
                        ? Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                              "Veuillez choisir la période que vous souhaitez vérifier.",
                                              style: GoogleFonts.cairo(
                                                  color: Color(0xff000000),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RaisedButton(
                                                color: Colors.blue,
                                                child: Text(
                                                    "cliquez pour choisir la période à vérifier",
                                                    style: GoogleFonts.cairo(
                                                        color:
                                                            Color(0xffffffff),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15)),
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (BuildContext
                                                          buildcontext) {
                                                        return Container(
                                                          height: 600,
                                                          child:
                                                              SfDateRangePicker(
                                                            view:
                                                                DateRangePickerView
                                                                    .month,
                                                            monthViewSettings:
                                                                DateRangePickerMonthViewSettings(
                                                                    firstDayOfWeek:
                                                                        1),
                                                            selectionMode:
                                                                DateRangePickerSelectionMode
                                                                    .range,
                                                            minDate: DateTime(
                                                                2021, 10, 30),
                                                            maxDate: DateTime(
                                                                DateTime.now()
                                                                    .year,
                                                                DateTime.now()
                                                                    .month,
                                                                DateTime.now()
                                                                    .day),
                                                            onSelectionChanged:
                                                                _onSelectedChanged,
                                                          ),
                                                        );
                                                      });
                                                }),
                                            RaisedButton(
                                                color: Colors.blue,
                                                onPressed: () {
                                                  getCreditPerDay();
                                                },
                                                child: Text("Consulter",
                                                    style: GoogleFonts.cairo(
                                                        color:
                                                            Color(0xffffffff),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15)))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 150,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Container(
                                            child: Text(
                                                "veuillez saisir le numéro de la commande que vous souhaitez vérifier",
                                                style: GoogleFonts.cairo(
                                                    color: Color(0xff000000),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: TextField(
                                                controller:
                                                    commandNumberController,
                                                scrollPadding:
                                                    EdgeInsets.only(bottom: 40),
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "Numero de commande",
                                                    hintText:
                                                        "Entrez le numero de commande",
                                                    prefixIcon:
                                                        Icon(Icons.warehouse),
                                                    suffix: IconButton(
                                                        icon: Icon(
                                                          Icons.search,
                                                          color: Colors.black,
                                                        ),
                                                        onPressed: () {
                                                          creditDetail(
                                                              commandNumberController
                                                                  .text);
                                                        })),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin: EdgeInsets.all(16),
                                    child: TextField(
                                      controller: clientNameController,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          hintText: "Nom du client",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.blue))),
                                      onChanged: searchClient,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                creditedClientsList()
                              ],
                            ),
                          )
                  ],
                )),
          ),
        ));
  }
}
