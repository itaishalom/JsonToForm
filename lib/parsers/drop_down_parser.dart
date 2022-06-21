import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/widgets/drop_down_widget.dart';

import '../json_to_form_with_theme.dart';

class DropDownModel extends ItemModel{
  final String? description;
  final String name;
  final List<String> values;
  int? time;
  dynamic chosenValue;

  @override
  void updateValue(value) {
    chosenValue = value;
    time = DateTime.now().millisecondsSinceEpoch;
  }
  DropDownModel.fromJson(Map<String, dynamic> json, String type, bool isBeforeHeader)
      : name = json['name'],
        description = json['description'],
        time = json['time'],
        values = json['values'].cast<String>(),
        chosenValue = json['chosen_value'], super(json['id'], type, isBeforeHeader);
}

class DropDownParserCreator extends ParserCreator<DropDownModel> {
  @override
  String get type => "drop_down";

  @override
  DropDownModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>
      DropDownModel.fromJson(json, type, isBeforeHeader);

  @override
  Widget createWidget(DropDownModel model, OnValueChanged? onValueChanged,
      DateBuilderMethod? dateBuilder, SaveBarBuilderMethod? savebarBuilder) =>
      DropDownWidget(
          key: ValueKey(model.id),
          model: model,
          dateBuilder: dateBuilder,
          onValueChanged: onValueChanged);
}
