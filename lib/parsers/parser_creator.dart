import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';

import '../json_to_form_with_theme.dart';

abstract class ParserCreator {
  String get type;

  WidgetParser parseFromJson(Map<String, dynamic> json,
      OnValueChanged? onValueChanged,
      bool isBeforeHeader,
      int index,
      Widget Function(int date, String id)? datebuilder);
}
