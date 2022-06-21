import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/widgets/static_text_value.dart';

import '../json_to_form_with_theme.dart';

class StaticTextModel extends ItemModel {
  final String? description;
  final String name;
  dynamic chosenValue;
  int? time;

  @override
  void updateValue(value) {
    chosenValue = value;
    time = DateTime.now().millisecondsSinceEpoch;
  }
  StaticTextModel.fromJson(Map<String, dynamic> json, String type,
      bool isBeforeHeader)
      :  name = json['name'],
        description = json['description'],
        time = json['time'],
        chosenValue = json['chosen_value'] ?? "", super(
        json['id'], type, isBeforeHeader);
}

class StaticTextParserCreator extends ParserCreator<StaticTextModel>{
  @override
  String get type => "static_text";

  @override
  StaticTextModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>  StaticTextModel.fromJson(json, type, isBeforeHeader);

  @override
  Widget createWidget(StaticTextModel model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder, SaveBarBuilderMethod? savebarBuilder)  => StaticTextValue(
    model: model,
    dateBuilder: dateBuilder,
      );
}
