library json_to_form_with_theme;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/exceptions/parsing_exception.dart';
import 'package:json_to_form_with_theme/parsers/drop_down_parser.dart';
import 'package:json_to_form_with_theme/parsers/edit_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/header_parser.dart';
import 'package:json_to_form_with_theme/parsers/static_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/toggle_parser.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/themes/inherited_json_form_theme.dart';

import 'package:json_to_form_with_theme/themes/json_form_theme.dart';
import 'package:json_to_form_with_theme/widgets/form.dart';

typedef OnValueChanged = void Function(String id, dynamic value);

class JsonForm extends StatefulWidget {
  final OnValueChanged onValueChanged;
  HashMap<int, WidgetParser> parsers = HashMap();
  final Map<String, dynamic> map;
  final JsonFormTheme theme;
  Stream<Map<String, dynamic>>? streamUpdates;

  JsonForm(
    Stream<Map<String, dynamic>>? stream, {Key? key,
    required this.onValueChanged,
    required this.map,
    required this.theme,
  }) : super(key: key) {
    streamUpdates = stream;
  }

  @override
  _JsonFormState createState() => _JsonFormState();
}

class _JsonFormState extends State<JsonForm> {
  HashMap<String, WidgetParser> parsers = HashMap();
  List<Widget> widgetsGlobal = [];
  late final StreamSubscription<Map<String, dynamic>>? _valueChange;

  @override
  void initState() {
    _valueChange = widget.streamUpdates?.listen(_onRemoteValueChanged);
    List<dynamic>? widgets = widget.map['widgets'];
    if (widgets == null) {
      throw const ParsingException("No widgets found");
    }
    widgetsGlobal = [];
    for (int i = 0; i < widgets.length; i++) {
      var widgetJson = widgets[i];
      String? type = widgetJson["type"];
      if (type == null) {
        throw const ParsingException("No type found on widget");
      }
      bool isBeforeHeader = false;
      if (i < widgets.length - 1) {
        var widgetTemp = widgets[i + 1];
        String? typeTemp = widgetTemp["type"];
        if (typeTemp == null) {
          throw const ParsingException("No type found on widget");
        }
        isBeforeHeader = typeTemp == "header";
      }
      WidgetParser? tempParser;
      switch (type) {
        case "toggle":
          tempParser = ToggleParser.fromJson(
              widgetJson, widget.onValueChanged, isBeforeHeader, i);
          break;
        case "header":
          tempParser = (HeaderParser.fromJson(widgetJson, i));
          break;
        case "static_text":
          tempParser = (StaticTextParser.fromJson(
              widgetJson, widget.onValueChanged, isBeforeHeader, i));
          break;
        case "drop_down":
          tempParser = (DropDownParser.fromJson(
              widgetJson, widget.onValueChanged, isBeforeHeader, i));
          break;
        case "edit_text":
          tempParser = (EditTextParser.fromJson(
              widgetJson, widget.onValueChanged, isBeforeHeader, i));
          break;
      }
      if (tempParser == null) {
        throw const ParsingException("Unknown type");
      }
      if(parsers.containsKey(tempParser.id)){
        throw ParsingException("Duplicate Id ${tempParser.id}");
      }
      parsers[tempParser.id] = tempParser;
      widgetsGlobal.add(tempParser.getWidget());
    }
    super.initState();
  }

  void _onRemoteValueChanged(Map<String, dynamic> values) {
    bool wasUpdated = false;
    for (String id in values.keys) {
      if (parsers[id] != null) {
        parsers[id]?.chosenValue = values[id];
        widgetsGlobal[parsers[id]!.index] = parsers[id]!.getWidget();
        wasUpdated = true;
      }
      if (wasUpdated) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InheritedJsonFormTheme(
        theme: widget.theme,
        child: Scaffold(
            backgroundColor: widget.theme.backgroundColor,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                TextEditingController().clear();
              },
              child: CustomScrollView(slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return widgetsGlobal[index];
                    },
                    childCount: widgetsGlobal.length,
                  ),
                )
              ]),
            )));
  }
}
