// ignore_for_file: unnecessary_this, unused_import, avoid_print, prefer_const_constructors, sort_child_properties_last, deprecated_member_use, unused_local_variable, non_constant_identifier_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:librairiedumaroc/views/apiKeyInput.dart';
import 'package:librairiedumaroc/views/home_page.dart';
import 'package:librairiedumaroc/views/salesPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
      ),
      debugShowCheckedModeBanner: false,
      home: apiKeyInput()
    );
  }
}
