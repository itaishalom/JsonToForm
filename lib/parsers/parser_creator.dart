import 'package:flutter/material.dart';
import 'package:json_to_form_with_theme/parsers/widget_parser.dart';

import '../json_to_form_with_theme.dart';
import 'edit_text_parser.dart';

abstract class ParserCreator<M extends Model> {
  String get type;

  M parseModel(Map<String, dynamic> json, bool isBeforeHeader);

  Widget createWidget(M model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder);
}

class EmptyCreator extends ParserCreator<EmptyModel>{
  @override
  Widget createWidget(EmptyModel model, OnValueChanged? onValueChanged, DateBuilderMethod? dateBuilder) => SizedBox();

  @override
  EmptyModel parseModel(Map<String, dynamic> json, bool isBeforeHeader) {
    // TODO: implement parseModel
    throw UnimplementedError();
  }

  @override
  // TODO: implement type
  String get type => throw UnimplementedError();

}