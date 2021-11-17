import 'package:flutter/cupertino.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';
import 'package:json_to_form_with_theme/widgets/edit_text_value.dart';
import 'package:json_to_form_with_theme/widgets/static_text_value.dart';
import 'package:json_to_form_with_theme/widgets/toggle.dart';

import '../json_to_form_with_theme.dart';

class EditTextParser implements WidgetParser {
  EditTextParser(this.name, this.description, this.id, this.chosenValue,
      this.onValueChanged, this.isBeforeHeader, this.index, this.debounceTime) {
    onValueChangedLocal = (String id, dynamic value) {
      chosenValue = value;
      if (onValueChanged != null) {
        onValueChanged!(id, value);
      }
    };
  }

  final OnValueChanged? onValueChanged;
  final String? description;
  final String name;
  final String id;
  final int? debounceTime;
  dynamic chosenValue;
  final bool isBeforeHeader;
  OnValueChanged? onValueChangedLocal;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'debounce_time': debounceTime,
        'chosen_value': chosenValue,
      };

  Widget getWidget() {
    return EditTextValue(
        name: name,
        id: id,
        debounceTime: debounceTime,
        description: description,
        chosenValue: chosenValue,
        key: ValueKey(id),
        isBeforeHeader: isBeforeHeader,
        onValueChanged: onValueChanged);
  }

  @override
  int index;

  @override
  set id(String _id) {
    // TODO: implement id
  }

  @override
  EditTextParser.fromJson(Map<String, dynamic> json, this.onValueChanged,
      this.isBeforeHeader, this.index)
      : name = json['name'],
        description = json['description'],
        debounceTime = json['debounce_time'],
        id = json['id'],
        chosenValue = json['chosen_value'] ?? "";
}
