import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/item_model.dart';
import 'package:json_to_form_with_theme/parsers/parser_creator.dart';
import 'package:json_to_form_with_theme/widgets/saveable_edit_text_value.dart';
import '../json_to_form_with_theme.dart';
import '../widgets/edit_text_value.dart';

class EditTextValueModel extends ItemModel {
  final String name;
  final String? description;
  bool isReadOnly = false;
  bool long = false;
  dynamic chosenValue;
  int? time;
  bool hasNext = false;

  @override
  void updateValue(value) {
    chosenValue = value;
    time = DateTime.now().millisecondsSinceEpoch;
  }

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
  @override
  String get type => "edit_text";

  EditTextValueModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) =>  EditTextValueModel.fromJson(json, type, isBeforeHeader);

  @override
  Widget createWidget(EditTextValueModel model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder, SaveBarBuilderMethod? savebarBuilder) {
    if (savebarBuilder == null) {
      return EditTextValue(
          key: ValueKey(model.id),
          model: model,
          onValueChanged: onValueChanged,
          dateBuilder: dateBuilder);
    }
    return SaveableEditTextValue(
        key: ValueKey(model.id),
        model: model,
        savebarBuilder: savebarBuilder,
        onValueChanged: onValueChanged,
        dateBuilder: dateBuilder);
  }
}
