import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/static_text_value.dart';
import 'package:json_to_form_with_theme/widgets/toggle.dart';

import '../json_to_form_with_theme.dart';

class StaticTextParser implements WidgetParser {
  StaticTextParser(this.name, this.description, this.id, this.chosenValue,
      this.onValueChanged, this.isBeforeHeader, this.index) {
    onValueChangedLocal = (String id, dynamic value) {
      chosenValue = value;
      onValueChanged(id, value);
    };
  }

  final OnValueChanged onValueChanged;
  final String? description;
  final String name;
  final String id;
  dynamic chosenValue;
  final bool isBeforeHeader;
  OnValueChanged? onValueChangedLocal;

  StaticTextParser.fromJson(
      Map<String, dynamic> json, this.onValueChanged, this.isBeforeHeader, this.index)
      : name = json['name'],
        description = json['description'],
        id = json['id'],
        chosenValue = json['chosen_value'] ?? "";

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'chosen_value': chosenValue,
      };

  Widget getWidget() {
    return StaticTextValue(
        name: name,
        id: id,
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
}
/*
this.name, this.description, this.id, this.chosenValue, this.values, this.onValueChanged){
onValueChangedLocal = (int id, dynamic value) {
chosenValue = value;
onValueChanged(id, value);*/
