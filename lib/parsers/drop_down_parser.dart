import 'package:flutter/cupertino.dart';
import 'package:json_to_form/parsers/widget_parser.dart';
import 'package:json_to_form/widgets/drop_down_widget.dart';
import 'package:json_to_form/widgets/toggle.dart';

import '../json_to_form.dart';

class DropDownParser implements WidgetParser{
  DropDownParser(
      this.name, this.description, this.id, this.chosenValue, this.values, this.onValueChanged, this.isBeforeHeader){
    onValueChangedLocal = (int id, dynamic value) {
      chosenValue = value;
      onValueChanged(id, value);
    };
  }

  final OnValueChanged onValueChanged;
  final bool isBeforeHeader;
  final String? description;
  final String name;
  final int id;
  final List<String> values;
  OnValueChanged? onValueChangedLocal;


  DropDownParser.fromJson(Map<String, dynamic> json, this.onValueChanged,  this.isBeforeHeader)
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
    return DropDownWidget(
        key: ValueKey(chosenValue),
        name: name,
        id: id,
        values: values,
        description: description,
        chosenValue: chosenValue,
        isBeforeHeader: isBeforeHeader,
        onValueChanged: onValueChanged);
  }

  @override
  dynamic chosenValue;

  @override
  set id(int _id) {
    // TODO: implement id
  }
}
