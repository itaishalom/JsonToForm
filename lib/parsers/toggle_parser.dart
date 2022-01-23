import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/toggle.dart';

import '../json_to_form_with_theme.dart';

class ToggleParser implements WidgetParser {
  ToggleParser(
      this.name,
      this.description,
      this.id,
      this.chosenValue,
      this.values,
      this.onValueChanged,
      this.isBeforeHeader,
      this.index,
      this.dateBuilder) {
    onValueChangedLocal = (String id, dynamic value) async {
      chosenValue = value;
      if (onValueChanged != null) {
        return await onValueChanged!(id, value);
      }
      return Future.value(true);
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
  final Widget Function(int date)? dateBuilder;
  int? time;

  ToggleParser.fromJson(Map<String, dynamic> json, this.onValueChanged,
      this.isBeforeHeader, this.index,
      [this.dateBuilder])
      : name = json['name'],
        description = json['description'],
        id = json['id'],
        time = json['time'],
        values = json['values'].cast<String>(),
        chosenValue = json['chosen_value'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'time': time,
        'values': values,
        'chosen_value': chosenValue,
      };

  Widget getWidget(bool refresh) {
    return Toggle(
        name: name,
        isBeforeHeader: isBeforeHeader,
        time: time,
        dateBuilder: dateBuilder,
        id: id,
        getUpdatedTime: (){return time;},
        getUpdatedValue: (){return chosenValue;},
        onTimeUpdated: (int newTime){time = newTime;},
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

  @override
  setChosenValue(value) {
    chosenValue = value;
  }
}
