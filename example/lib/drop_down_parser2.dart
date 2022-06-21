import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';

import 'drop_down_widget2.dart';

class DropDownParser2Model extends ItemModel{
  dynamic chosenValue;
  final String? description;
  final String name;
  final List<String> values;
  int? time;

  DropDownParser2Model.fromJson(Map<String, dynamic> json, String type, bool isBeforeHeader)
      : name = json['name'],
        description = json['description'],
        time = json['time'],
        values = json['values'].cast<String>(),
        chosenValue = json['chosen_value'], super(json['id'], type, isBeforeHeader);

}

class DropDownParser2Creator extends ParserCreator<DropDownParser2Model>{
  @override
  String get type => "drop_down2";

  @override
  Widget createWidget(DropDownParser2Model model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder, SaveBarBuilderMethod? saveBarBuilderMethod) => DropDownWidget2(
      key: ValueKey(model.id),
      model: model,
      dateBuilder: dateBuilder,
      onValueChanged: onValueChanged);

  @override
  DropDownParser2Model parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>DropDownParser2Model.fromJson(json, type, isBeforeHeader);
}
