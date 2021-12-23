import 'package:flutter/widgets.dart';
import 'package:json_to_form_with_theme/exceptions/parsing_exception.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser_factory.dart';
import 'drop_down_parser2.dart';

class MyWidgetParserFactory implements WidgetParserFactory{
  @override
  WidgetParser? getWidgetParser(
      String type,
      int index,
      Map<String, dynamic> widgetJson,
      bool isBeforeHeader,
      OnValueChanged? onValueChanged,
      Widget Function(int date)? dateBuilder) {
    switch (type) {
      case "drop_down2":
        try {
          return DropDownParser2.fromJson(
              widgetJson, onValueChanged, isBeforeHeader, index);
        } catch (e) {
          throw const ParsingException("Bad drop_down2 format");
        }
    }
    return null;
  }
}

