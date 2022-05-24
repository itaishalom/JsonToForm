import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/json_to_form_with_theme.dart';
import 'package:json_to_form_with_theme/parsers/edit_text_parser.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';

import 'drop_down_widget2.dart';
class DropDownParser2Model extends Model{
  dynamic chosenValue;
  final String? description;
  final String name;
  final String id;
  final List<String> values;
  int? time;

  DropDownParser2Model.fromJson(Map<String, dynamic> json, String type, bool isBeforeHeader)
      : name = json['name'],
        description = json['description'],
        id = json['id'],
        time = json['time'],
        values = json['values'].cast<String>(),
        chosenValue = json['chosen_value'], super(json['id'], type, isBeforeHeader);

}
class DropDownParser2Creator extends ParserCreator<DropDownParser2Model>{
  String get type => "drop_down2";

  @override
  Widget createWidget(DropDownParser2Model model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder) => DropDownWidget2(
      key: ValueKey(model.id),
      model: model,
      dateBuilder: dateBuilder,
      onValueChanged: onValueChanged);

  @override
  DropDownParser2Model parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>DropDownParser2Model.fromJson(json, type, isBeforeHeader);
}
