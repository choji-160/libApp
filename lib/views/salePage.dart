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
import '../services/Credits.dart';
import '../services/SoldArticles.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class salePage extends StatefulWidget {
  final String num;
  const salePage({Key? key, required this.num}) : super(key: key);

  @override
  State<salePage> createState() => _salePageState(num: num);
}

class _salePageState extends State<salePage> {
  final String num;
  _salePageState({required this.num});
  List<Sale>? sales;
  List<Sale>? salesToday;
  List<SoldArticle>? soldarticles;
  List<SoldArticle>? soldarticlesNum;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from api
    getSale();
    getSoldArticle();
  }

  getSale() async {
    sales = await Sales().getSales();
    salesToday =
        sales?.where((element) => element.numeroCommande == num).toList();
    if (sales != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  getSoldArticle() async {
    soldarticles = await SoldArticles().getSoldArticles();
    soldarticlesNum = soldarticles
        ?.where((element) => element.numeroCommande == num)
        .toList();
    if (soldarticles != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawerScrimColor: Color(0xff000000),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.blue[900]),
          backgroundColor: Color(0xfff4a261),
          elevation: 0,
          centerTitle: true,
        ),
        body: Visibility(
          visible: isLoaded,
          replacement: Container(
              color: Color(0xfff4a261),
              child: Center(
                  child: CircularProgressIndicator(color: Colors.white))),
          child: Container(
            color: Color(0xfff4a261),
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
                            "Informations générales sur la commande : ${num.toString()}",
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
                                    "Client : ${salesToday?[0].client.toString()}",
                                    style: GoogleFonts.cairo(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Utilisateur: ${salesToday?[0].utilisateur.toString()}",
                                    style: GoogleFonts.cairo(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "M_paiement : ${salesToday?[0].mPaiement.toString()}",
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
                                    "Nombre articles : ${salesToday?[0].nombreArticle.toString()}",
                                    style: GoogleFonts.cairo(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Totale : ${salesToday?[0].totale.toString()}",
                                    style: GoogleFonts.cairo(
                                      color: Color(0xff000000),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Type : ${salesToday?[0].type.toString().substring(0, 2)}",
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
                    child: soldarticlesNum == null
                        ? Container(
                            child: Center(
                                child: CircularProgressIndicator(
                                    color: Colors.white)))
                        : Container(
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
                                              "Designation : ${soldarticlesNum?[index].designation}",
                                              style: GoogleFonts.cairo(
                                                color: Color(0xff000000),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "Quantité : ${soldarticlesNum?[index].quantite}",
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
                                                  "Prix : ${soldarticlesNum?[index].prix}",
                                                  style: GoogleFonts.cairo(
                                                    color: Color(0xff000000),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Remise : ${soldarticlesNum?[index].remise}",
                                                  style: GoogleFonts.cairo(
                                                    color: Color(0xff000000),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Totale : ${soldarticlesNum?[index].total}",
                                                  style: GoogleFonts.cairo(
                                                    color: Color(0xff000000),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "TVA : ${soldarticlesNum?[index].tva}",
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
          ),
        ));
  }
}
