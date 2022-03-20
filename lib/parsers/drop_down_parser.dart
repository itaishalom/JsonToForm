import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/drop_down_widget.dart';

import '../json_to_form_with_theme.dart';

class DropDownParser implements WidgetParser {
  DropDownParser(
      this.name,
      this.description,
      this.id,
      this.chosenValue,
      this.values,
      this.onValueChanged,
      this.isBeforeHeader,
      this.index,
      this.dateBuilder);

  final OnValueChanged? onValueChanged;
  final bool isBeforeHeader;
  final String? description;
  final String name;
  final String id;
  final List<String> values;
  OnValueChanged? onValueChangedLocal;
  final Widget Function(int date, String id)? dateBuilder;
  int? time;

  DropDownParser.fromJson(Map<String, dynamic> json, this.onValueChanged,
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
    return DropDownWidget(
        key: ValueKey(id),
        name: name,
        id: id,
        getUpdatedTime: (){return time;},
        getUpdatedValue: (){return chosenValue;},
        onTimeUpdated: (int newTime){time = newTime;},
        values: values,
        time: time,
        dateBuilder: dateBuilder,
        description: description,
        onValueChanged: (String id, dynamic value) async{
          if (chosenValue != value) {
            chosenValue = value;
            if (onValueChanged != null) {
              return await onValueChanged!(id, value);
            }
          }
          return false;
        },
        chosenValue: chosenValue,
        isBeforeHeader: isBeforeHeader,);
  }

  @override
  dynamic chosenValue;

  @override
  set id(String _id) {
    // TODO: implement id
  }

  @override
  int index;

  StreamController<String?>? _onUserController;


  @override
  setChosenValue(value) {
    chosenValue = value ?? "";
  }
}
