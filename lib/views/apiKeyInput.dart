// ignore_for_file: file_names, implementation_imports, unnecessary_import, camel_case_types, avoid_unnecessary_containers, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:librairiedumaroc/views/home_page.dart';

TextEditingController apiController = TextEditingController();
String apiKey = apiController.text;

class apiKeyInput extends StatefulWidget {
  const apiKeyInput({super.key});

  @override
  State<apiKeyInput> createState() => _apiKeyInputState();
}

class _apiKeyInputState extends State<apiKeyInput> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
            child: Center(
                child: Image.asset(
          'lib/assets/black logo-8.png',
          width: MediaQuery.of(context).size.width * 0.8,
        ))),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 7,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: apiController,
                  decoration: InputDecoration(
                      labelText: "Cle API prive",
                      labelStyle: TextStyle(color: Colors.blue),
                      prefixIcon: Icon(Icons.key, color: Colors.blue),
                      hintText: "Cle API prive",
                      hintStyle: TextStyle(color: Colors.blue),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white))),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Center(
                    child: IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
                        },
                        icon: Icon(
                          Icons.arrow_circle_right,
                          color: Colors.blue,
                          size: 50,
                        )),
                  )),
            ],
          ),
        ))
      ]),
    );
  }
}
