import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class clientsPage extends StatefulWidget {
  const clientsPage({Key? key}) : super(key: key);

  @override
  State<clientsPage> createState() => _clientsPageState();
}

class _clientsPageState extends State<clientsPage> {
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
        body: Container());
    
  }
}