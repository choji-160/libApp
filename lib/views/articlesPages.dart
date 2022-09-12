// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, must_call_super, sort_child_properties_last, unused_import, unused_local_variable, avoid_print, prefer_const_literals_to_create_immutables, duplicate_import, deprecated_member_use, body_might_complete_normally_nullable, sized_box_for_whitespace, unrelated_type_equality_checks, prefer_is_empty, file_names, await_only_futures

import 'dart:ffi';
import 'dart:io';

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
import 'package:pdf/pdf.dart';

class articlesPage extends StatefulWidget {
  const articlesPage({Key? key}) : super(key: key);

  @override
  State<articlesPage> createState() => _articlesPageState();
}

class _articlesPageState extends State<articlesPage> {
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
  List<Article>? result;
  var isLoaded = false;

  @override
  void initState() {
    super.initState();

    //fetch data from api
    getArticle();
  }

  getArticle() async {
    articles = await Articles().getArticles();
    result = await articles;
    if (articles != null && result != null) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  final articleNameController = TextEditingController();
  void searchClient(String value) {
    setState(() {
      result = articles!;
    });
    final suggestions = articles!.where((element) {
      final article = element.designation.toString().toLowerCase();
      final input = value.toLowerCase();
      return article.contains(input);
    }).toList();
    setState(() => result = suggestions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          title: Text(
            'Les articles',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.all(16),
                  child: TextField(
                    controller: articleNameController,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.warehouse),
                        hintText: "Nom article",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blue))),
                    onChanged: searchClient,
                  )),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: result?.length,
                      itemBuilder: (BuildContext bc, index) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                  color: Colors.blue,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Nom : ${result?[index].designation}",
                                          style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Code Barre : ${result?[index].codeBarre}",
                                          style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                            Text(
                                              "date : ${result?[index].datee}",
                                              style: GoogleFonts.cairo(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "Prix achat : ${result?[index].prixAchat?.toStringAsFixed(2)}",
                                              style: GoogleFonts.cairo(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Prix vente : ${result?[index].prixVent?.toStringAsFixed(2)}",
                                              style: GoogleFonts.cairo(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Quantite : ${result?[index].quantit}",
                                              style: GoogleFonts.cairo(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        );
                      }))
            ],
          ),
        ));
  }
}
