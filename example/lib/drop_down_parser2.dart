import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';

import 'drop_down_widget2.dart';

class DropDownParser2Creator extends ParserCreator{
  String get type => "drop_down2";
  WidgetParser parseFromJson(Map<String, dynamic> json,
      OnValueChanged? onValueChanged,
      bool isBeforeHeader,
      int index,
      Widget Function(int date, String id)? datebuilder) =>
      DropDownParser2.fromJson(json, onValueChanged, isBeforeHeader, index);
}

class DropDownParser2 implements WidgetParser {
  DropDownParser2(
      this.name,
      this.description,
      this.id,
      this.chosenValue,
      this.values,
      this.onValueChanged,
      this.isBeforeHeader,
      this.index,
      this.dateBuilder) {
    onValueChangedLocal = (String id, dynamic value) async{
      chosenValue = value;
      if (onValueChanged != null) {
        return await onValueChanged!(id, value);
      }
      return Future.value(true);
    };
  }

  final OnValueChanged? onValueChanged;
  final bool isBeforeHeader;
  final String? description;
  final String name;
  final String id;
  final List<String> values;
  OnValueChanged? onValueChangedLocal;
  final Widget Function(int date, String id)? dateBuilder;
  int? time;

  DropDownParser2.fromJson(Map<String, dynamic> json, this.onValueChanged,
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
    return DropDownWidget2(
        key: ValueKey(chosenValue),
        name: name,
        id: id,
        values: values,
        description: description,
        chosenValue: chosenValue,
        dateBuilder: dateBuilder,
        time: time,
        isBeforeHeader: isBeforeHeader,
        onValueChanged: onValueChanged);
  }

  @override
  dynamic chosenValue;

  @override
  set id(String _id) {
    // TODO: implement id
  }

  @override
  int index;

  @override
  setChosenValue(value) {
    // TODO: implement setChosenValue
    chosenValue = value ?? "";
  }

}
