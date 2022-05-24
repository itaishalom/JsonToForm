import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/edit_text_value.dart';

import '../json_to_form_with_theme.dart';

abstract class Model{
  final String id;
  final String type;
  final bool isBeforeHeader;

  Model(this.id, this.type, this.isBeforeHeader);
}
class EmptyModel extends Model{
  EmptyModel() : super("empty", "empty", false);
}

class EditTextValueModel extends Model{
  final String name;
  final String? description;
  bool isReadOnly = false;
  bool long = false;
  dynamic chosenValue;
  int? time;

  EditTextValueModel.fromJson(Map<String, dynamic> json, String type, bool isBeforeHeader)
      : name = json['name'],
        description = json['description'],
        time = json['time'],
        long = json["long"] ?? false,
        isReadOnly = json['read_only'] ?? false,
        chosenValue = json['chosen_value'] ?? "", super(json['id'], type, isBeforeHeader);

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'id': id,
    'chosen_value': chosenValue,
    'read_only': isReadOnly,
    'time': time,
    'long': long
  };
}
class EditTextParserCreator extends ParserCreator<EditTextValueModel>{
  String get type => "edit_text";

  EditTextValueModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>  EditTextValueModel.fromJson(json, type, isBeforeHeader);

  @override
  Widget createWidget(EditTextValueModel model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder) {
    return EditTextValue(
        key: ValueKey(model.id),
        model: model,
        onValueChanged: onValueChanged,
        dateBuilder: dateBuilder);
  }
}
