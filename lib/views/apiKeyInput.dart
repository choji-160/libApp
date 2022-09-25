// ignore_for_file: file_names, implementation_imports, unnecessary_import, camel_case_types, avoid_unnecessary_containers, prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously, annotate_overrides, must_call_super

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:librairiedumaroc/views/home_page.dart';
import 'package:input_history_text_field/input_history_text_field.dart';

TextEditingController apiKeyController = TextEditingController();
String? apiKey;

class apiKeyInput extends StatefulWidget {
  const apiKeyInput({super.key});

  @override
  State<apiKeyInput> createState() => _apiKeyInputState();
}

class _apiKeyInputState extends State<apiKeyInput> {
  FocusNode? focusNode;

  void initState() {
    focusNode = FocusNode();

    // listen to focus changes
    focusNode!.addListener(() {});
  }

  void setFocus() {
    FocusScope.of(context).requestFocus(focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        Center(
            child: Image.asset(
          'lib/assets/black logo-8.png',
          width: MediaQuery.of(context).size.width * 0.8,
        )),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: InputHistoryTextField(
              focusNode: focusNode,
              textEditingController: apiKeyController,
              historyKey: "01",
              onChanged: (value) {
                setState(() {
                  apiKey = value;
                });
              },
              historyListItemLayoutBuilder: (controller, value, index) {
                return InkWell(
                  onTap: () {
                    apiKeyController.text = value.text;
                    setState(() {
                      apiKey = value.text;
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            value.textToSingleLine,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.close,
                          size: 16,
                          color: Theme.of(context).disabledColor,
                        ),
                        onPressed: () {
                          controller.remove(value);
                        },
                      ),
                    ],
                  ),
                );
              }),
        ),
        Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Text("confimer")))
      ],
    ));
  }
}
