import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/edit_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/static_text_value.dart';

import '../json_to_form_with_theme.dart';

class StaticTextModel extends Model {
  final String? description;
  final String name;
  dynamic chosenValue;
  int? time;

  StaticTextModel.fromJson(Map<String, dynamic> json, String type,
      bool isBeforeHeader)
      :  name = json['name'],
        description = json['description'],
        time = json['time'],
        chosenValue = json['chosen_value'] ?? "", super(
        json['id'], type, isBeforeHeader);
}
class StaticTextParserCreator extends ParserCreator<StaticTextModel>{
  String get type => "static_text";

  StaticTextModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>  StaticTextModel.fromJson(json, type, isBeforeHeader);

  Widget createWidget(StaticTextModel model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder)  => StaticTextValue(
    model: model,
    dateBuilder: dateBuilder,
      );
}
