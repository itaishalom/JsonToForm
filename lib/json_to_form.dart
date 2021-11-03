library json_to_form;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form/exceptions/parsing_exception.dart';
import 'package:json_to_form/parsers/drop_down_parser.dart';
import 'package:json_to_form/parsers/header_parser.dart';
import 'package:json_to_form/parsers/static_text_parser.dart';
import 'package:json_to_form/parsers/toggle_parser.dart';
import 'package:json_to_form/parsers/widget_parser.dart';
import 'package:json_to_form/themes/inherited_json_form_theme.dart';
import 'package:json_to_form/themes/json_form_theme.dart';

typedef OnValueChanged = void Function(int id, dynamic value);

/// A JsonToForm.
class JsonToForm {
  final OnValueChanged onValueChanged;
  List<WidgetParser> parsers = [];
  final JsonFormTheme theme;

  JsonToForm(
      {required this.onValueChanged,
      required String arrayText,
      required this.theme}) {
    var tagsJson = jsonDecode(arrayText)['widgets'];
  }

  JsonToForm.fromMap(
      {required this.onValueChanged,
      required Map<String, dynamic> map,
      required this.theme}) {
    List<dynamic>? widgets = map['widgets'];
    if (widgets == null) {
      throw const ParsingException("No widgets found");
    }
    for (int i = 0; i< widgets.length; i++ ) {
      var widget = widgets[i];
      String? type = widget["type"];
      if (type == null) {
        throw const ParsingException("No type found on widget");
      }
      bool isBeforeHeader = false;
      if(i < widgets.length - 1){
        var widgetTemp = widgets[i+1];
        String? typeTemp = widgetTemp["type"];
        if (typeTemp == null) {
          throw const ParsingException("No type found on widget");
        }
        isBeforeHeader = typeTemp == "header";
      }
      switch (type) {
        case "toggle":
          parsers.add(ToggleParser.fromJson(widget, onValueChanged, isBeforeHeader));
          break;
        case "header":
          parsers.add(HeaderParser.fromJson(widget));
          break;
        case "static_text":
          parsers.add(StaticTextParser.fromJson(widget, onValueChanged, isBeforeHeader));
          break;
        case "drop_down":
          parsers.add(DropDownParser.fromJson(widget, onValueChanged, isBeforeHeader));
          break;
      }
    }
  }

  Widget getWidget() {
    List<Widget> widgets = [];

    for (WidgetParser parser in parsers) {
      widgets.add(parser.getWidget());
    }
    return InheritedJsonFormTheme(
        theme: theme,
        child: Scaffold(backgroundColor: theme.backgroundColor,
            body:
        CustomScrollView(slivers:
        <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
             return widgets[index];
              },
              childCount: widgets.length,
            ),
          )
        ]
        )
        )
    );
  }
}
