import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/toggle.dart';

import '../json_to_form_with_theme.dart';

class ToggleParser implements WidgetParser {
  ToggleParser(this.name, this.description, this.id, this.chosenValue,
      this.values, this.onValueChanged, this.isBeforeHeader, this.index) {
    onValueChangedLocal = (String id, dynamic value) {
      chosenValue = value;
      if (onValueChanged != null) {
        onValueChanged!(id, value);
      }
    };
  }

  final OnValueChanged? onValueChanged;
  final String? description;
  final String name;
  final String id;
  final List<String> values;
  dynamic? chosenValue;
  OnValueChanged? onValueChangedLocal;
  final bool isBeforeHeader;

  ToggleParser.fromJson(Map<String, dynamic> json, this.onValueChanged,
      this.isBeforeHeader, this.index)
      : name = json['name'],
        description = json['description'],
        id = json['id'],
        values = json['values'].cast<String>(),
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

  @override
  set id(String _id) {
    // TODO: implement id
  }

  @override
  int index;

}
