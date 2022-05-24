import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/static_text_value.dart';

import '../json_to_form_with_theme.dart';

class StaticTextParserCreator extends ParserCreator{
  String get type => "static_text";
  WidgetParser parseFromJson(Map<String, dynamic> json,
      OnValueChanged? onValueChanged,
      bool isBeforeHeader,
      int index,
      Widget Function(int date, String id)? datebuilder) =>
      StaticTextParser.fromJson(json, onValueChanged, isBeforeHeader, index);
}

class StaticTextParser implements WidgetParser {
  StaticTextParser(this.name, this.description, this.id, this.chosenValue,
      this.onValueChanged, this.isBeforeHeader, this.index, this.dateBuilder) {
  }

  final OnValueChanged? onValueChanged;
  final String? description;
  final String name;
  final String id;
  dynamic chosenValue;
  final bool isBeforeHeader;
  OnValueChanged? onValueChangedLocal;
  final Widget Function(int date, String id)? dateBuilder;
  int? time;

  StaticTextParser.fromJson(Map<String, dynamic> json, this.onValueChanged,
      this.isBeforeHeader, this.index,
      [this.dateBuilder])
      : name = json['name'],
        description = json['description'],
        id = json['id'],
        time = json['time'],
        chosenValue = json['chosen_value'] ?? "";

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'chosen_value': chosenValue,
        'time': time
      };

  Widget getWidget(bool refresh) {
    return StaticTextValue(
        name: name,
        id: id,
        time: time,
        dateBuilder: dateBuilder,
        description: description,
        chosenValue: chosenValue,
        isBeforeHeader: isBeforeHeader);
  }

  @override
  set id(String _id) {
    // TODO: implement id
  }

  @override
  int index;

  @override
  setChosenValue(value) {
    chosenValue = value ?? "";
  }
}
/*
this.name, this.description, this.id, this.chosenValue, this.values, this.onValueChanged){
onValueChangedLocal = (int id, dynamic value) {
chosenValue = value;
onValueChanged(id, value);*/
