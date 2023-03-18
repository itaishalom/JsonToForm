import 'dart:async';
import 'dart:math';
import 'package:example/drop_down_parser2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/themes/json_form_theme.dart';
import 'package:sizer/sizer.dart';

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
  MyHomePage({Key? key, required this.title}) : super(key: key) {}

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stream<Map<String, dynamic>>? onValueChangeStream;
  final StreamController<Map<String, dynamic>> _onUserController = StreamController<Map<String, dynamic>>();

  // Map<String, WidgetParser> dynamics = {};

  final Map<String, dynamic> json = {
    "widgets": [
      {"type": "header", "name": "Header", "id": "29"},
      {
        "id": "1",
        "name": "DVT",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": null,
        "time": 1630164109066,
      },
      {"type": "header", "name": "Header2", "id": "39"},
      {
        "id": "56",
        "name": "ADVT",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": "Off",
        "time": 1630164109056,
      },
      {
        "id": "2",
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value which is long value",
        "description": "(description..)",
        "time": 1640164109066,
      },
      {
        "id": "26",
        "name": "Long name of the line but a short",
        "type": "static_text",
        "chosen_value": "value",
        "description": "(description..)",
        "time": 1640164109066,
      },
      {
        "id": "3",
        "name": "Blood Pressure with a long long long",
        "type": "edit_text",
        "chosen_value": "A",
        "time": 1640260609562,
        "description": "mmHg - with a long description",
      },
      {"type": "header", "name": "Header", "id": "99"},
      {
        "id": "4",
        "name": "Drop down",
        "type": "drop_down",
        "time": 1640264109066,
        "values": ["Low-Intermediate", "Medium", "High", ""],
        "chosen_value": "Low-Intermediate"
      },
      {
        "id": "5",
        "name": "Dynamic Drop down",
        "type": "drop_down2",
        "values": ["Low-Intermediate", "Medium", "High", ""],
        "chosen_value": "Low-Intermediate",
        "time": 1530164109066,
      },
      {"type": "header", "name": "Header", "id": "10029"},
      {
        "id": "1001",
        "name": "DVT",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": null,
        "time": 1630164109066,
      },
      {"type": "header", "name": "Header2", "id": "10039"},
      {
        "id": "10056",
        "name": "ADVT",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": "Off",
        "time": 1630164109056,
      },
      {
        "id": "1002",
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value which is long value",
        "description": "(description..)",
        "time": 1640164109066,
      },
      {
        "id": "10026",
        "name": "Long name of the line but a short",
        "type": "static_text",
        "chosen_value": "value",
        "description": "(description..)",
        "time": 1640164109066,
      },
      {
        "id": "1003",
        "name": "Blood Pressure with a long long long",
        "type": "edit_text",
        "chosen_value": "B",
        "time": 1640260609562,
        "description": "mmHg - with a long description",
      },
      {"type": "header", "name": "Header", "id": "10099"},
      {
        "id": "1004",
        "name": "Drop down",
        "type": "drop_down",
        "time": 1640264109066,
        "values": ["Low-Intermediate", "Medium", "High", ""],
        "chosen_value": "Low-Intermediate"
      },
  /*    {
        "id": "1005",
        "name": "Dynamic Drop down",
        "type": "drop_down2",
        "values": ["one", "two", "three"],
        "chosen_value": "one",
        "time": 1530164109066,
      },*/
      {"type": "header", "name": "Header", "id": "20029"},
      {
        "id": "2001",
        "name": "DVT",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": null,
        "time": 1630164109066,
      },
      {"type": "header", "name": "Header2", "id": "20039"},
      {
        "id": "20056",
        "name": "ADVT",
        "type": "toggle",
        "values": ["On", "Off"],
        "chosen_value": "Off",
        "time": 1630164109056,
      },
      {
        "id": "2002",
        "name": "Static text",
        "type": "static_text",
        "chosen_value": "value which is long value",
        "description": "(description..)",
        "time": 1640164109066,
      },
      {
        "id": "20026",
        "name": "Long name of the line but a short",
        "type": "static_text",
        "chosen_value": "value",
        "description": "(description..)",
        "time": 1640164109066,
      },
      {
        "id": "2003",
        "name": "Blood Pressure with a long long long",
        "type": "edit_text",
        "chosen_value": "c",
        "time": 1640260609562,
        "description": "mmHg - with a long description",
      },
      {"type": "header", "name": "Header", "id": "20099"},
      {
        "id": "2004",
        "name": "Drop down",
        "type": "drop_down",
        "time": 1640264109066,
        "values": ["Low-Intermediate", "Medium", "High", ""],
        "chosen_value": "Low-Intermediate"
      },
/*      {
        "id": "2005",
        "name": "Dynamic Drop down",
        "type": "drop_down2",
        "values": ["one", "two", "three"],
        "chosen_value": "one",
        "time": 1530164109066,
      }*/
    ]
  };

  @override
  void initState() {
    super.initState();
    onValueChangeStream = _onUserController.stream.asBroadcastStream();
  }

  String buildDate(DateTime dateTime) {
    final now = DateTime.now();
    int diff = now.millisecondsSinceEpoch - dateTime.millisecondsSinceEpoch;

    if (diff < dayInMilliseconds) {
      return build24String(diff);
    } else if (diff >= dayInMilliseconds && diff < monthInMilliseconds) {
      return buildDaysString(diff);
    } else if (diff >= monthInMilliseconds && diff < yearInMilliseconds) {
      return buildMonthString(dateTime);
    }
    return dateTime.year.toString();
  }

  String buildDaysString(int diff) {
    int days = diff ~/ dayInMilliseconds;
    return "${days}d";
  }

  String buildMonthString(DateTime dateTime) {
    return DateFormat.MMMd().format(dateTime);
  }

  int yearInMilliseconds = 31556952000;
  int monthInMilliseconds = 2629800000;
  int weekInMilliseconds = 604800000;
  int dayInMilliseconds = 86400000;
  int hourInMilliseconds = 3600000;
  int minuteInMilliseconds = 60000;

  String build24String(int diff) {
    int hours = diff ~/ hourInMilliseconds;
    int minutes = (diff - (hours * hourInMilliseconds)) ~/ minuteInMilliseconds;
    return "${hours}h ${minutes}m";
  }

  Widget dateBuilder(int date, String id) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);
    return Text(buildDate(dateTime));
  }
  Widget saveBarBuilder({required Function onSave, required Function onClose}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          children: [
            ElevatedButton(
                onPressed: ()=> onClose(),
                child: Text("close")),
            Spacer(),
            ElevatedButton(
                onPressed: ()=> onSave(),
                child: Text("save")),
          ]),
    );
  }

  List<String> list = ["Medium", "High"];
  List<String> toggleList = ["On", "Off"];

  int counter = 0;
  int toggle = 1;

  bool changeToGoodBad = true;

  Future<dynamic> _refresh() {
    //"chosen_value": "Low-Intermediate"
    if (changeToGoodBad) {
      toggleList = ['Good', "Bad"];
      json['widgets'][1]['values'] = toggleList;
      json['widgets'][1]['chosen_value'] = "Bad";
      json['widgets'][6]['chosen_value'] = "goodReally";
      json['widgets'][8]['chosen_value'] = "Medium";
      json['widgets'][9]['chosen_value'] = "Medium";

    } else {
      toggleList = ["On", "Off"];
      json['widgets'][1]['chosen_value'] = "On";
      json['widgets'][1]['values'] = toggleList;
      json['widgets'][6]['chosen_value'] = "bad";
      json['widgets'][8]['chosen_value'] = "High";
      json['widgets'][9]['chosen_value'] = "High";
    }

    changeToGoodBad = !changeToGoodBad;
    setState(() {});
    return Future.delayed(const Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation, DeviceType deviceType) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Floating Action Button'),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: JsonFormWithThemeBuilder(
                jsonWidgets: json)
                .setDateBuilderMethod(dateBuilder)//
             .registerComponent(DropDownParserCreator())
                // .setDynamicFactory(MyWidgetParserFactory())
                .setStreamUpdates(onValueChangeStream)
                .setOnValueChanged((String d, dynamic s) async {
                  print("Update id $d to value $s");
                  await Future.delayed(const Duration(seconds: 1));
                  return Future.value(true);
                })
               .setSaveBarBuilderMethod(saveBarBuilder)
               .setTheme(const DefaultTheme()).build(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              counter++;
              if (counter % 5 == 1) {
                toggle++;
                _onUserController.add({}..["1"] = toggleList[toggle % 2]); // toggle
              }
              if (counter % 5 == 2) {
                _onUserController.add({}..["2"] = "updated" + Random().nextInt(10).toString()); // toggle
              }
              if (counter % 5 == 3) {
                _onUserController.add({}..["3"] = "Val" + Random().nextInt(100000).toString()); // toggle
              }
              if (counter % 5 == 4) {
                _onUserController.add({}..["4"] = list[toggle % 2]); // toggle
              }
              if (counter % 5 == 0) {
                _onUserController.add({}..["5"] = list[toggle % 2]); // toggle
              }
            },
            child: const Icon(Icons.navigation),
            backgroundColor: Colors.green,
          ),
        );
      },
    );
  }
}
