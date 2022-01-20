import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/drop_down_widget.dart';

import '../json_to_form_with_theme.dart';
import '../stream_cache.dart';

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
  final Widget Function(int date)? dateBuilder;
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
    if(refresh) {
      StreamCache.getStreamRefresh(id).add(true);
    }
    return DropDownWidget(
        key: ValueKey(id),
        name: name,
        id: id,
        values: values,
        time: time,
        dateBuilder: dateBuilder,
        description: description,
        chosenValue: chosenValue,
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

  StreamController<String?>? _onUserController;


  @override
  setChosenValue(value) {
    chosenValue = value ?? "";
  //  StreamCache.getStream(id).add(chosenValue);
  }
}
