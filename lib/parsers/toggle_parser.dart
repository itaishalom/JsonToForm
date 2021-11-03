import 'package:flutter/cupertino.dart';
import 'package:json_to_form/parsers/widget_parser.dart';
import 'package:json_to_form/widgets/toggle.dart';

import '../json_to_form.dart';

class ToggleParser implements WidgetParser{
  ToggleParser(
      this.name, this.description, this.id, this.chosenValue, this.values, this.onValueChanged, this.isBeforeHeader){
    onValueChangedLocal = (int id, dynamic value) {
      chosenValue = value;
      onValueChanged(id, value);
    };
  }

  final OnValueChanged onValueChanged;
  final String? description;
  final String name;
  final int id;
  final List<String> values;
  int? chosenValue;
  OnValueChanged? onValueChangedLocal;
  final bool isBeforeHeader;


  ToggleParser.fromJson(Map<String, dynamic> json, this.onValueChanged, this.isBeforeHeader)
      : name = json['name'],
        description = json['description'],
        id = json['id'],
        values = json['values'],
        chosenValue = json['chosen_value'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'values': values,
        'chosen_value': chosenValue,
      };


  Widget getWidget() {
    return Toggle(
        name: name,
        isBeforeHeader: isBeforeHeader,
        id: id,
        values: values,
        description: description,
        chosenValue: chosenValue,
        onValueChanged: onValueChanged);
  }
}
