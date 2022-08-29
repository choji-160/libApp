// ignore_for_file: prefer_const_literals_to_create_immutables, unnecessary_import, implementation_imports, camel_case_types, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:librairiedumaroc/views/articlesPages.dart';
import 'package:librairiedumaroc/views/clientsPage.dart';
import 'package:librairiedumaroc/views/creditsPage.dart';
import 'package:librairiedumaroc/views/salesPage.dart';

class navBar extends StatefulWidget {
  const navBar({Key? key}) : super(key: key);

  @override
  State<navBar> createState() => _navBarState();
}

class _navBarState extends State<navBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 50, 8, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xff277BC0))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const salesPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "Les Ventes",
                  style: GoogleFonts.cairo(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xffFF9551))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const creditsPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "Les Credits",
                  style: GoogleFonts.cairo(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xff7FB77E))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const clientsPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "Les Clients",
                  style: GoogleFonts.cairo(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xff76549A))),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const articlesPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  "Les Articles",
                  style: GoogleFonts.cairo(
                      color: Color(0xffffffff),
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
