// ignore_for_file: prefer_const_constructors, implementation_imports, unnecessary_import, camel_case_types, deprecated_member_use, unused_element, avoid_print, sized_box_for_whitespace, prefer_if_null_operators, unnecessary_null_comparison, body_might_complete_normally_nullable, unused_local_variable, prefer_is_empty, avoid_unnecessary_containers, unnecessary_string_interpolations, prefer_const_literals_to_create_immutables, sort_child_properties_last, file_names

import 'package:flutter/foundation.dart';
import 'package:librairiedumaroc/views/salesdetailpagefortheday.dart';
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
import '../api/pdf_api.dart';
import '../services/Credits.dart';
import '../services/SoldArticles.dart';

class salesPage extends StatefulWidget {
  const salesPage({Key? key}) : super(key: key);

  @override
  State<salesPage> createState() => _salesPageState();
}

class _salesPageState extends State<salesPage> {
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
  num? creditsSumTotal;
  num? creditsSumAvance;
  num? returnssum;
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

    if (sales != null &&
        soldarticles != null &&
        articles != null &&
        clients != null &&
        credits != null &&
        returns != null &&
        returnedArticles != null) {
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

  // _onSelectedChanged(
  //     DateRangePickerSelectionChangedArgs
  //         dateRangePickerSelectionChangedArgs) async {
  //   print(dateRangePickerSelectionChangedArgs.value.toString().contains("null"));
  //   PickerDateRange dateRange =
  //       dateRangePickerSelectionChangedArgs.value.toString().contains("null") ==
  //               true
  //           ? null
  //           : await dateRangePickerSelectionChangedArgs.value;
  //   if (dateRange != null) {
  //     startDate = dateRange.toString().split(",")[0];
  //     endDate = dateRange.toString().split(",")[1];
  //   }
  // }

  late List<DateTime> days;
  updateDates(DateTime startDateAsDate, DateTime endDateAsDate) {
    print(startDateAsDate);
    print(endDateAsDate);
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
  Widget? saleDetails(String num) {
    getSoldArticlesNum(num);
    List<Sale> commandeSale =
        sales!.where(((element) => element.numeroCommande == num)).toList();
    commandeSale.length == 0 && soldarticlesNum!.length == 0
        ? showDialog(
            context: context,
            barrierDismissible: true,
            builder: (BuildContext buildContext) => AlertDialog(
                  actions: [
                    ElevatedButton(
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
                                "Informations générales sur la commande : $num",
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
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        String fileName =
                                            num.toString().replaceAll("/", "-");
                                        List<SoldArticle> prod = [];
                                        for (var product in soldarticlesNum!) {
                                          prod.add(product);
                                        }
                                        final pdfFile =
                                            await PdfApi.generateTable(
                                          fileName,
                                          prod,
                                          commandeSale[0].totale.toString(),
                                          commandeSale[0].client.toString(),
                                        );
                                        PdfApi.openFile(pdfFile);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            "Ticket",
                                            style: GoogleFonts.cairo(
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.receipt,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xff023047)),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                flex: 1,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: soldarticlesNum?.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        child: Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Prix : ${soldarticlesNum![index].prix}",
                                                      style: GoogleFonts.cairo(
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Remise : ${soldarticlesNum![index].remise}",
                                                      style: GoogleFonts.cairo(
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Totale : ${soldarticlesNum![index].total}",
                                                      style: GoogleFonts.cairo(
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      "TVA : ${soldarticlesNum![index].tva}",
                                                      style: GoogleFonts.cairo(
                                                        color:
                                                            Color(0xff000000),
                                                        fontWeight:
                                                            FontWeight.bold,
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
                      ),
                    ),
                  ],
                ),
              );
            });
  }

  getStatisticsPerDay() {
    updateDates(DateTime.parse(startDate!.substring(0, 10)),
        DateTime.parse(endDate!.substring(0, 10)));
    List salesTotals = [];
    List creditsTotals = [];
    List returnsTotals = [];
    num periodSalesSum = 0;
    num periodCreditsSum = 0;
    num periodReturnsSum = 0;
    salesTotals.clear();
    creditsTotals.clear();
    returnsTotals.clear();
    for (var day in days) {
      salessum = 0;
      creditsSumTotal = 0;
      creditsSumAvance = 0;
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
        creditsSumTotal = creditsSumTotal! +
            (creditsToday![e].total == null ? 0 : creditsToday![e].total!);
        creditsSumAvance = creditsSumAvance! +
            (creditsToday![e].avance == null ? 0 : creditsToday![e].avance!);
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
      creditsTotals.add(((creditsSumTotal! - creditsSumAvance!) < 0
          ? 0.toStringAsFixed(2)
          : (creditsSumTotal! - creditsSumAvance!).toStringAsFixed(2)));
      // creditsTotals.add((creditsSumTotal!).toStringAsFixed(2));
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
                Text("Statistiques des ventes entre",
                    style: GoogleFonts.cairo(
                        color: Color(0xff000000),
                        fontWeight: FontWeight.bold,
                        fontSize: 15)),
                Text(
                    "${days[0].day}/${days[0].month}/${days[0].year} et ${days[days.length - 1].day}/${days[days.length - 1].month}/${days[days.length - 1].year}",
                    style: GoogleFonts.cairo(
                        color: Color(0xff000000),
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
                                color: Color(0xff000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                    '${periodSalesSum.toStringAsFixed(2)}',
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
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "Credit",
                              style: GoogleFonts.cairo(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(
                              "Retour",
                              style: GoogleFonts.cairo(
                                color: Color(0xff000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                    "${periodReturnsSum.toStringAsFixed(2)}",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Le ${days[index].day}/${days[index].month}/${days[index].year}',
                                        style: GoogleFonts.cairo(
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue),
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
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15)),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            color: Color(0xff000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                    colors: const [
                                                  Color(0xff00B4DB),
                                                  Color(0xff0083B0)
                                                ],
                                                    begin: Alignment.topLeft,
                                                    end:
                                                        Alignment.bottomRight)),
                                            child: Center(
                                              child: Text(
                                                num.parse(salesTotals[index]) -
                                                            num.parse(
                                                                creditsTotals[
                                                                    index]) -
                                                            num.parse(
                                                                returnsTotals[
                                                                    index]) <
                                                        0
                                                    ? "0 DH"
                                                    : '${(num.parse(salesTotals[index]) - num.parse(creditsTotals[index]) - num.parse(returnsTotals[index])).toStringAsFixed(2)} DHS',
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
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
        });
  }

  DateRangePickerController _dateRangePickerController =
      DateRangePickerController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          'Les ventes',
          style: GoogleFonts.cairo(
              color: Color(0xff000000),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Visibility(
            visible: isLoaded,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: Padding(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: Text(
                              "cliquez pour choisir la période à vérifier",
                              style: GoogleFonts.cairo(
                                  color: Color(0xffffffff),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext buildcontext) {
                                  return Container(
                                    height: 600,
                                    child: SfDateRangePicker(
                                      showActionButtons: true,
                                      onSubmit: (val) {
                                        getStatisticsPerDay();
                                      },
                                      controller: _dateRangePickerController,
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                      view: DateRangePickerView.month,
                                      monthViewSettings:
                                          DateRangePickerMonthViewSettings(
                                              firstDayOfWeek: 1),
                                      selectionMode:
                                          DateRangePickerSelectionMode.range,
                                      minDate: DateTime(2021, 10, 30),
                                      maxDate: DateTime(
                                          DateTime.now().year,
                                          DateTime.now().month,
                                          DateTime.now().day),
                                      onSelectionChanged:
                                          (DateRangePickerSelectionChangedArgs
                                              args) {
                                        setState(() {
                                          startDate =
                                              args.value.startDate.toString();
                                          endDate =
                                              args.value.endDate.toString();
                                        });
                                      },
                                    ),
                                  );
                                });
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 200,
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
                          controller: commandNumberController,
                          scrollPadding: EdgeInsets.only(bottom: 40),
                          decoration: InputDecoration(
                              labelText: "Numero de commande",
                              hintText: "Entrez le numero de commande",
                              prefixIcon: Icon(Icons.warehouse),
                              suffix: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    saleDetails(commandNumberController.text);
                                  })),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
