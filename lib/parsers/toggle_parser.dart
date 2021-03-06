import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/widgets/toggle.dart';
import '../json_to_form_with_theme.dart';

class ToggleModel extends ItemModel{
  final String? description;
  final String name;
  final List<String> values;
  dynamic chosenValue;
  int? time;

  @override
  void updateValue(value) {
    chosenValue = value;
    time = DateTime.now().millisecondsSinceEpoch;
  }

  ToggleModel.fromJson(Map<String, dynamic> json, String type, bool isBeforeHeader)
      :name = json['name'],
        description = json['description'],
        time = json['time'],
        values = json['values'].cast<String>(),
        chosenValue = json['chosen_value'],  super(json['id'], type, isBeforeHeader);
}

class ToggleParserCreator extends ParserCreator<ToggleModel>{
  @override
  String get type => "toggle";

  @override
  Widget createWidget(ToggleModel model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder, SaveBarBuilderMethod? savebarBuilder)  =>  Toggle(
      model : model,
      dateBuilder: dateBuilder,
      onValueChanged: onValueChanged);

  @override
  ToggleModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) => ToggleModel.fromJson(json, type, isBeforeHeader);
}
