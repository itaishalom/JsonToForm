import 'package:flutter/cupertino.dart';
import 'package:json_to_form/parsers/widget_parser.dart';
import 'package:json_to_form/widgets/edit_text_value.dart';
import 'package:json_to_form/widgets/static_text_value.dart';
import 'package:json_to_form/widgets/toggle.dart';

import '../json_to_form.dart';

class EditTextParser implements WidgetParser {
  EditTextParser(this.name, this.description, this.id, this.chosenValue,
      this.onValueChanged, this.isBeforeHeader) {
    onValueChangedLocal = (int id, dynamic value) {
      chosenValue = value;
      onValueChanged(id, value);
    };
  }

  final OnValueChanged onValueChanged;
  final String? description;
  final String name;
  final int id;
  String chosenValue;
  final bool isBeforeHeader;
  OnValueChanged? onValueChangedLocal;

  EditTextParser.fromJson(
      Map<String, dynamic> json, this.onValueChanged, this.isBeforeHeader)
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
    return EditTextValue(
        name: name,
        id: id,
        description: description,
        chosenValue: chosenValue,
        isBeforeHeader: isBeforeHeader);
  }
}
/*
this.name, this.description, this.id, this.chosenValue, this.values, this.onValueChanged){
onValueChangedLocal = (int id, dynamic value) {
chosenValue = value;
onValueChanged(id, value);*/
