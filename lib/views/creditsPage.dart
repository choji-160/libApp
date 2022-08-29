import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class creditsPage extends StatefulWidget {
  const creditsPage({Key? key}) : super(key: key);

  @override
  State<creditsPage> createState() => _creditsPageState();
}

class _creditsPageState extends State<creditsPage> {
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
        body: Container());
    
  }
}