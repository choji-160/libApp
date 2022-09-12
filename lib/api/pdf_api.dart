// ignore_for_file: depend_on_referenced_packages, import_of_legacy_library_into_null_safe, unused_local_variable, prefer_const_constructors, unused_import, duplicate_import, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts_arabic/fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
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
import 'package:intl/intl.dart' as pw;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts_arabic/fonts.dart';

class PdfApi {
  static Future<File> generateTable(
    String comNum,
    List<SoldArticle> prod,
    String Total,
    String clientName,
  ) async {
    final font = await rootBundle.load('fonts/Cairo-VariableFont_wght.ttf');
    final pdf = Document();
    final logo = (await rootBundle.load('lib/assets/black logo-8.png'))
        .buffer
        .asUint8List();
    final data = prod
        .map((product) => [
              product.designation,
              product.prix,
              product.quantite,
              product.remise,
              product.tva
            ])
        .toList();
    pdf.addPage(
      Page(
          theme: ThemeData.withFont(
            base: Font.ttf(font),
          ),
          build: (context) {
            return Container(
                child: Column(children: [
              Center(child: Image(MemoryImage(logo))),
              SizedBox(height: 10),
              Text("Nom du client : $clientName",
                  style: TextStyle(fontSize: 4)),
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Numero Commande : $comNum",
                        style: TextStyle(fontSize: 4)),
                    SizedBox(width: 5),
                    Text(
                        "Date : ${prod[0].dateVentArticle.toString().substring(0, 10)}",
                        style: TextStyle(fontSize: 4))
                  ]),
              SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                    width: 50,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Designation",
                              style: TextStyle(
                                fontSize: 5,
                                fontFallback: [Font.ttf(font)],
                              )),
                        ])),
                Expanded(
                    flex: 1,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 20,
                              child: Center(
                                child:
                                    Text("Prix", style: TextStyle(fontSize: 5)),
                              )),
                          Container(
                              width: 20,
                              child: Center(
                                child:
                                    Text("Qte", style: TextStyle(fontSize: 5)),
                              )),
                          Container(
                            width: 20,
                            child: Center(
                                child: Text("Remise",
                                    style: TextStyle(fontSize: 5))),
                          ),
                          Container(
                              width: 20,
                              child: Center(
                                  child: Text("Totale",
                                      style: TextStyle(fontSize: 5))))
                        ])),
              ]),
              Divider(color: PdfColors.black),
              Column(children: [
                for (var product in prod)
                  Container(
                      child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              width: 50,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${product.designation}",
                                        textDirection: product.designation!
                                                    .contains(RegExp('^[a-zA-Z]')) ==
                                                true
                                            ? TextDirection.ltr
                                            : TextDirection.rtl,
                                        style: TextStyle(
                                            fontSize: 4,
                                            fontFallback: [Font.ttf(font)])),
                                  ])),
                          Expanded(
                              flex: 1,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        width: 20,
                                        child: Center(
                                          child: Text("${product.prix}",
                                              style: TextStyle(fontSize: 4)),
                                        )),
                                    Container(
                                        width: 20,
                                        child: Center(
                                          child: Text("${product.quantite}",
                                              style: TextStyle(fontSize: 4)),
                                        )),
                                    Container(
                                      width: 20,
                                      child: Center(
                                          child: Text("${product.remise}",
                                              style: TextStyle(fontSize: 4))),
                                    ),
                                    Container(
                                        width: 20,
                                        child: Center(
                                            child: Text("${product.tva}",
                                                style: TextStyle(fontSize: 4))))
                                  ])),
                        ]),
                    Divider(color: PdfColors.black)
                  ]))
              ]),
              SizedBox(height: 10),
              Text("Totale : $Total")
            ]));
          },
          pageFormat: PdfPageFormat.roll57),
    );

    return saveDocument(name: '$comNum.pdf', pdf: pdf);
  }

  static Future<File> generateImage() async {
    final pdf = Document();

    final imageSvg = await rootBundle.loadString('assets/fruit.svg');
    final imageJpg =
        (await rootBundle.load('assets/person.jpg')).buffer.asUint8List();

    final pageTheme = PageTheme(
      pageFormat: PdfPageFormat.a4,
      buildBackground: (context) {
        if (context.pageNumber == 1) {
          return FullPage(
            ignoreMargins: true,
            child: Image(MemoryImage(imageJpg), fit: BoxFit.cover),
          );
        } else {
          return Container();
        }
      },
    );

    pdf.addPage(
      MultiPage(
        pageTheme: pageTheme,
        build: (context) => [
          Container(
            height: pageTheme.pageFormat.availableHeight - 1,
            child: Center(
              child: Text(
                'Foreground Text',
                style: TextStyle(color: PdfColors.white, fontSize: 48),
              ),
            ),
          ),
          SvgImage(svg: imageSvg),
          Image(MemoryImage(imageJpg)),
          Center(
            child: ClipRRect(
              horizontalRadius: 32,
              verticalRadius: 32,
              child: Image(
                MemoryImage(imageJpg),
                width: pageTheme.pageFormat.availableWidth / 2,
              ),
            ),
          ),
          GridView(
            crossAxisCount: 3,
            childAspectRatio: 1,
            children: [
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
              SvgImage(svg: imageSvg),
            ],
          )
        ],
      ),
    );

    return saveDocument(name: 'my_example.pdf', pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
