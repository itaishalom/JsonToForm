import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/header.dart';

import '../json_to_form_with_theme.dart';
class HeaderParserCreator extends ParserCreator{
  String get type => "header";
  WidgetParser parseFromJson(Map<String, dynamic> json,
      OnValueChanged? onValueChanged,
      bool isBeforeHeader,
      int index,
      Widget Function(int date, String id)? datebuilder) =>
      HeaderParser.fromJson(json, index);
}

class HeaderParser implements WidgetParser {
  HeaderParser(this.name, this.id, this.index);

  final String name;
  final String id;

  HeaderParser.fromJson(Map<String, dynamic> json, this.index)
      : name = json['name'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
      };

  Widget getWidget(bool refresh) {
    return Header(
      name: name,
      id: id,
    );
  }

  @override
  dynamic chosenValue = "";

  @override
  set id(String _id) {
    // TODO: implement id
  }

  @override
  int index;

  @override
  int? time;

  @override
  setChosenValue(value) {
    // TODO: implement setChosenValue
  }

}
