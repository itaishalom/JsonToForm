library json_to_form;

import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_to_form/exceptions/parsing_exception.dart';
import 'package:json_to_form/parsers/drop_down_parser.dart';
import 'package:json_to_form/parsers/edit_text_parser.dart';
import 'package:json_to_form/parsers/header_parser.dart';
import 'package:json_to_form/parsers/static_text_parser.dart';
import 'package:json_to_form/parsers/toggle_parser.dart';
import 'package:json_to_form/parsers/widget_parser.dart';

import 'package:json_to_form/themes/json_form_theme.dart';
import 'package:json_to_form/widgets/form.dart';

typedef OnValueChanged = void Function(int id, dynamic value);

/// A JsonToForm.
class JsonToForm {
  final OnValueChanged onValueChanged;
  final Function triggerRefresh;
  List<WidgetParser> parsers = [];
  List<Widget> widgetsGlobal = [];
  final JsonFormTheme theme;
  final HashMap<String, Widget> idToWidget = HashMap();

  JsonToForm(
      {required this.onValueChanged,
      required this.triggerRefresh,
      required String arrayText,
      required this.theme}) {
    var tagsJson = jsonDecode(arrayText)['widgets'];
  }

  JsonToForm.fromMap(
      {required this.onValueChanged,     required this.triggerRefresh,
      required Map<String, dynamic> map,
      required this.theme}) {
    List<dynamic>? widgets = map['widgets'];
    if (widgets == null) {
      throw const ParsingException("No widgets found");
    }
    for (int i = 0; i < widgets.length; i++) {
      var widget = widgets[i];
      String? type = widget["type"];
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
      switch (type) {
        case "toggle":
          parsers.add(
              ToggleParser.fromJson(widget, onValueChanged, isBeforeHeader));
          break;
        case "header":
          parsers.add(HeaderParser.fromJson(widget));
          break;
        case "static_text":
          parsers.add(StaticTextParser.fromJson(
              widget, onValueChanged, isBeforeHeader));
          break;
        case "drop_down":
          parsers.add(
              DropDownParser.fromJson(widget, onValueChanged, isBeforeHeader));
          break;
        case "edit_text":
          parsers.add(
              EditTextParser.fromJson(widget, onValueChanged, isBeforeHeader));
          break;
      }
    }
    widgetsGlobal = [];
    for (WidgetParser parser in parsers) {
      widgetsGlobal.add(parser.getWidget());
    }
  }

  void onUpdate(int id, dynamic value) {
    for (int i = 0; i < widgetsGlobal.length; i++) {
      if (parsers[i].id == id) {
        parsers[i].chosenValue = value;
        widgetsGlobal[i] = parsers[i].getWidget();
        triggerRefresh();
        break;
      }
    }
  }

  final GlobalKey<JsonFormState> _key = GlobalKey();

  Widget getForm(BuildContext context) {
    return JsonForm(theme: theme, widgets: widgetsGlobal);
  }
}
