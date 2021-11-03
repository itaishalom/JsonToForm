import 'package:flutter/material.dart';
import 'package:json_to_form/json_to_form.dart';
import 'package:json_to_form/themes/json_form_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key) {
    form = JsonToForm.fromMap(
        onValueChanged: (int d, dynamic s) {},
        map: json,
        theme: const DefaultTheme());
  }

  JsonToForm? form;

  final Map<String, dynamic> json = {
    "widgets": [
      {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      }, {
      "id": 1,
      "name": "Toggle",
      "type": "toggle",
      "values": ["On", "Off"],
      "default_value": "0",
      "chosen_value": 1
    },{
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },   {
        "id": 1,
        "name": "Toggle",
        "type": "toggle",
        "values": ["On", "Off"],
        "default_value": "0",
        "chosen_value": 1
      },
      {
        "id": 2,
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value",
        "description" :"(description..)",
      },
      {
        "id": 2,
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value",
        "description" :"(description..)",
      },
      {
        "id": 2,
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value",
        "description" :"(description..)",
      },
      {"type": "header", "name": "Header"},
      {
        "id": 2,
        "name": "Drop down",
        "type": "drop_down",
        "values": [
          "a",
          "b",
          "c"
        ],
        "default_value": "2"
      }
    ]
  };

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
/*  var json = {
    "widgets": [
      {
        "type": "header",
        "name": "History"
      },
      {
        "id": 1,
        "name": "blabla",
        "type": "toggle",
        "values": [
          "On",
          "Off"
        ],
        "default_value": "0",
        "chosen_value": 1
      },
      {
        "id": 2,
        "name": "some drop",
        "type": "drop_down",
        "values": [
          "a",
          "b",
          "c"
        ],
        "default_value": "2"
      },
      {
        "id": 3,
        "type": "number_input",
        "default_value": "28",
        "name": "Pressure"
      }
    ]
  };*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: widget.form?.getWidget()),
    );
  }
}
